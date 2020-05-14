#!/bin/bash
set -e
if [ -z ${1} ]; then
  echo "\n🤥 No namespace found, please pass this script one 🤥 eg: \n\n./argo-generate-token.sh labs-ci-cd  \n"
  exit -1
fi

OC_NAMESPACE=$1
ARGOCD_PASSWD=$(oc get secret argocd-cluster -o jsonpath='{.data.admin\.password}' -n ${OC_NAMESPACE} | base64 -d)

argocd login --insecure --grpc-web $(oc get routes argocd-server -o jsonpath='{.spec.host}' -n ${OC_NAMESPACE}) \
  --username admin --password ${ARGOCD_PASSWD}

ARGOCD_TOKEN=$(argocd account generate-token)

echo "🎟 Token is:"
echo "${ARGOCD_TOKEN}"