#!/usr/bin/env python3
import json
import requests
from requests.exceptions import RequestException
import urllib3
import os
import shutil
import re
from subprocess import Popen, PIPE, DEVNULL
from prometheus_client import parser
import csv

urllib3.disable_warnings()

outDir = 'snapshot_metrics_out'
prometheusUrl = 'https://127.0.0.1:30443/prometheus'
kubernetesUser = 'user'
metricsCountFile = '%s/metrics.csv' % outDir

if os.path.isdir(outDir):
    try:
        shutil.rmtree(outDir)
    except OSError as e:
        print("Error: %s - %s." % (e.filename, e.strerror))
os.mkdir(outDir)


def get_valid_filename(s):
    # Initially copied from https://github.com/django/django/blob/master/django/utils/text.py
    s = str(s).strip().replace(' ', '_').replace(':', '_').replace('/', '_')
    return re.sub(r'(?u)[^-\w.]', '', s)


def fetchBearerToken():
    fetchCommand = 'kubectl --namespace=monitoring exec -it prometheus-k8s-0 -- cat /var/run/secrets/kubernetes.io/serviceaccount/token'

    pipe = Popen(["su", kubernetesUser],
                 stdin=PIPE,
                 stdout=PIPE,
                 stderr=DEVNULL,
                 universal_newlines=True)
    (bearerToken, _) = pipe.communicate(fetchCommand)
    return bearerToken


def listTargets():
    headers = {'Content-Type': 'application/json', 'Host': 'infra.k8s.test'}
    apiUrl = '%s/api/v1/targets' % prometheusUrl

    response = requests.get(apiUrl, headers=headers, verify=False)

    targetsFile = '%s/targets.json' % outDir
    with open(targetsFile, 'w') as outfile:
        outfile.write(response.text)

    targetsJson = json.loads(response.text)
    return targetsJson


def callOneTarget(job, instance, scrapeUrl):
    print('Calling %s on %s' % (job, instance))
    targetFileName = '%s_%s' % (get_valid_filename(job),
                                get_valid_filename(instance))
    targetFile = '%s/%s.prom' % (outDir, targetFileName)

    headers = {}
    if bearerToken:
        headers['Authorization'] = 'Bearer %s' % bearerToken

    try:
        response = requests.get(scrapeUrl,
                                headers=headers,
                                verify=False,
                                timeout=30)
        countMetrics(job, instance, targetFile, response.text)
        with open(targetFile, 'w') as outfile:
            outfile.write(response.text)
    except RequestException as e:
        print("Error: %s" % e)


def initMetricsCount(csvfile):
    metricsCountWriter = csv.writer(csvfile)
    metricsCountWriter.writerow(
        ['Job', 'Instance', 'Name', 'Samples', 'Exported file', 'Doc'])
    return metricsCountWriter


def countMetrics(job, instance, targetFile, content):
    metrics = parser.text_string_to_metric_families(content)
    for metric in metrics:
        metricsCountWriter.writerow([
            job, instance, metric.name,
            len(metric.samples), targetFile, metric.documentation
        ])


bearerToken = fetchBearerToken()
targetsJson = listTargets()
with open(metricsCountFile, 'w') as csvfile:
    metricsCountWriter = initMetricsCount(csvfile)
    for t in targetsJson['data']['activeTargets']:
        callOneTarget(t['discoveredLabels']['job'], t['labels']['instance'],
                      t['scrapeUrl'])
