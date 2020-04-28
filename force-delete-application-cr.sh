#!/bin/bash
if [ -z ${1} ]; then
  echo "\n🤥 No namespace found, please pass this script it otherwise ALL ARGO APP CRs will be deleted 🤥 eg: \n\n./force-delete-application-cr.sh labs-ci-cd  \n"
  exit -1
fi

OC_TOKEN="${TOKEN:-$(oc whoami -t)}"
OC_REST_API_URL="${REST_API_URL:-$(oc whoami --show-server)}"
OC_NAMESPACE=$1

if [ -z ${OC_TOKEN} ]; then
  echo "\n👻 Please Login to OpenShift ... 👻\n"
  exit -1
fi

echo "👾 Using: ${OC_REST_API_URL} and ${OC_NAMESPACE} namespace 👾"

APPLICATIONS=$(curl --insecure --silent -H "Content-Type: application/json" -H "Authorization: Bearer ${OC_TOKEN}" ${OC_REST_API_URL}/apis/argoproj.io/v1alpha1/namespaces/${OC_NAMESPACE}/applications | jq -r '.items[].metadata.name')
declare -a APPS_ARRAY=($APPLICATIONS)

## now loop through the above array
counter=1
echo "\n🐙🐙 List of Application CRs about to be deleted from ${OC_NAMESPACE}🗡🗡"

for i in "${APPS_ARRAY[@]}"
do
   echo "$counter - $i"
   let counter=counter+1
done

echo "\n💤💤 Sleeping for 3 seconds in case this was a mistake.... 💤💤"
sleep 3
echo "... Guess not ... 🙀😿\n"

unameOut="$(uname -s)"
case "${unameOut}" in
    Linux*)     sedargs=-i;;
    Darwin*)    sedargs='-i "" -e';;
    *)          echo "not on Linux or Mac ?" && exit -1
esac

for app in "${APPS_ARRAY[@]}"
do
  echo "\n🐙🗡  Kill -9 ${app}"
  curl --insecure --silent -H "Content-Type: application/json" -H "Authorization: Bearer ${OC_TOKEN}" \
    ${OC_REST_API_URL}/apis/argoproj.io/v1alpha1/namespaces/${OC_NAMESPACE}/applications/${app} | jq '.' > ${app}-delete.json
  echo sed $sedargs "s#\\\"resources-finalizer.argocd.argoproj.io\\\"##g" ${app}-delete.json | sh
  deleted=$(curl --insecure --silent -H "Content-Type: application/json" -H "Authorization: Bearer ${OC_TOKEN}" \
     -X PUT --data-binary @${app}-delete.json \
    ${OC_REST_API_URL}/apis/argoproj.io/v1alpha1/namespaces/${OC_NAMESPACE}/applications/${app} | jq -r '.metadata.name')
  echo "☠💀 deleted: ${deleted} 💀☠️"
  rm ${app}-delete.json
done
