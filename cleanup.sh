#!/bin/bash

unset KUBECONFIG

echo "Logging into OpenShift"
oc login <OPENSHIFT_API_URL> \
    --username=<OPENSHIFT_USERNAME> \
    --password=<OPENSHIFT_PASSWORD> \
    --insecure-skip-tls-verify=true

echo "Logging into OpenShift image registry"
podman login \
  --username <OPENSHIFT_USERNAME> \
  --password $(oc whoami -t) \
  --tls-verify=false \
  <OPENSHIFT_REGISTRY_URL>

echo "Deleting Openliberty Trace"
oc -n <OPENSHIFT_PROJECT> delete oltrace ol-trace

echo "Deleting OpenLiberty Dump"
oc -n <OPENSHIFT_PROJECT> delete oldump ol-dump

echo "Removing PVC reference from OpenLibertyApplication
oc patch openlibertyapplication appmod -p '{"spec":{"serviceability":{"volumeClaimName":null}}}' --type=merge

echo "Deleting PVC"
oc -n <OPENSHIFT_PROJECT> delete pvc ol-pvc-day2

ech "Deleting PV"
oc delete pv pv-ol-day2
