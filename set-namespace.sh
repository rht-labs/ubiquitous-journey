#!/bin/bash
# ./set-namespace.sh $ci_cd_namespace $dev_namespace $test_namespace
if [ -z ${1} ] || [ -z ${2} ] || [ -z ${3} ]; then
  echo "🤥 No namespaces specified - please set them 🤥 "
  echo "./set-namespace.sh \$ci_cd_namespace \$dev_namespace \$test_namespace"
  echo "For example:"
  echo "./set-namespace.sh my-ci-cd my-dev my-test"
  exit -1
fi

unameOut="$(uname -s)"
case "${unameOut}" in
    Linux*)     sedargs=-i;;
    Darwin*)    sedargs='''-i '' -e''';;
    *)          echo "not on Linux or Mac ?" && exit -1
esac

sed $sedargs "s#\"labs-ci-cd\"#\"${1}\"#g" bootstrap/values-bootstrap.yaml
sed $sedargs "s#\"labs-dev\"#\"${2}\"#g" bootstrap/values-bootstrap.yaml
sed $sedargs "s#\"labs-test\"#\"${3}\"#g" bootstrap/values-bootstrap.yaml

sed $sedargs "s#labs-dev#${2}#g" example-deployment/values-applications.yaml

sed $sedargs "s#labs-ci-cd#${1}#g" ubiquitous-journey/values-tooling.yaml

echo "🐙 All done - happy helming 🐙"
