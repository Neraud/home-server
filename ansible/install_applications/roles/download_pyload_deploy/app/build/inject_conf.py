#!/usr/bin/env python2
import sys
sys.path.append('/opt/pyload/')

import os
import __builtin__
__builtin__.pypath = '/opt/pyload/'
from module.ConfigParser import ConfigParser

envNamePrefix = "PYLOAD_CONF_"
os.chdir('/opt/pyload-data')

print('Reading configuration')
config = ConfigParser()

for param in os.environ.keys():
    if param.startswith(envNamePrefix):
        propertySection, propertyName = param[len(envNamePrefix):].split("_", 1)
        propertyValue = os.environ[param]
        print(" - injecting %s - %s = %s" % (propertySection, propertyName, propertyValue))
        config.set(propertySection, propertyName, propertyValue)

print('Saving configuration')
config.save()
