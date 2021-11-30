#!/bin/bash
# ./patch-gitops-operator.sh $argocd_ns

if [ -z ${1} ]; then
  echo "🤥 No namespace specified - please set one 🤥 "
  echo "./patch-gitops-operator.sh \$argocd_ns"
  echo "For example:"
  echo "./patch-gitops-operator.sh labs-ci-cd"
  exit -1
fi

export ARGOCD_NAMESPACE=${1}

run()
{
  NS=$(oc get subscription/openshift-gitops-operator -n openshift-operators \
    -o jsonpath='{.spec.config.env[?(@.name=="ARGOCD_CLUSTER_CONFIG_NAMESPACES")].value}')
  if [ -z $NS ]; then
    NS="${ARGOCD_NAMESPACE}"
  elif [[ "$NS" =~ .*"${ARGOCD_NAMESPACE}".* ]]; then
    echo "${ARGOCD_NAMESPACE} already added."
    return
  else
    NS="${ARGOCD_NAMESPACE},${NS}"
  fi
  oc -n openshift-operators patch subscription/openshift-gitops-operator --type=json \
    -p '[{"op":"replace","path":"/spec/config/env/1","value":{"name": "ARGOCD_CLUSTER_CONFIG_NAMESPACES", "value":"'${NS}'"}}]'
  echo "EnvVar set to: $(oc get subscription/openshift-gitops-operator -n openshift-operators \
    -o jsonpath='{.spec.config.env[?(@.name=="ARGOCD_CLUSTER_CONFIG_NAMESPACES")].value}')"
}
run