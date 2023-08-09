#!/usr/bin/env bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
sensor_file_path=$SCRIPT_DIR/deploy/sensors/sensor.yaml

echo "Listing applications"
app_list=$(find $SCRIPT_DIR/.. -mindepth 1 -maxdepth 1 -type d -exec basename {} \;)

echo "Found $(echo $app_list | wc -w) apps"


echo "Generate sensor"
cat <<EOF > $sensor_file_path
apiVersion: argoproj.io/v1alpha1
kind: Sensor
metadata:
  name: git
  namespace: dev-argo-tasks
spec:
  eventBusName: default
  template:
    serviceAccountName: operate-workflow-sa
    container:
      resources:
        requests:
          cpu: 10m
          memory: 32Mi
        limits:
          cpu: 100m
          memory: 128Mi
    nodeSelector:
      capability/general-purpose: 'yes'
  dependencies:
EOF


echo " - generate dependencies"
for app in $app_list ; do
    cat <<EOF >> $sensor_file_path
    - name: $app-git-dep
      eventSourceName: webhook
      eventName: git
      filters:
        data:
          - path: header.X-Gitea-Event
            type: string
            value:
              - push
          - path: body.ref
            type: string
            value:
              - refs/heads/develop
          - path: "[body.commits.#.modified.#()#,body.commits.#.added.#()#,body.commits.#.removed.#()#]"
            type: string
            value:
              - "apps/(base|vagrant)/$app/.*"
EOF
done


echo " - generate triggers"
cat <<EOF >> $sensor_file_path
  triggers:
EOF

for app in $app_list ; do
    cat <<EOF >> $sensor_file_path
    - template:
        name: $app-argo-workflow-trigger
        conditions: $app-git-dep
        argoWorkflow:
          operation: submit
          source:
            resource:
              apiVersion: argoproj.io/v1alpha1
              kind: Workflow
              metadata:
                namespace: dev-argo-tasks
                generateName: $app-build-and-deploy-
              spec:
                entrypoint: build-and-deploy-from-git
                synchronization:
                  mutex:
                    name: $app-build-and-deploy
                arguments:
                  parameters:
                    - name: app_name
                      value: $app
                    - name: base_git_repo
                      value: http://gitea.dev-gitea.svc.cluster.local:3000/MyOrg/home-server.git
                    - name: base_git_branch
                      value: develop
                workflowTemplateRef:
                  name: app-build-and-deploy
EOF
done
