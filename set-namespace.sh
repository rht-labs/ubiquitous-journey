#!/bin/bash
# ./set-namespace.sh $ci_cd_ns $dev_ns $test_ns $staging_ns

if [ -z ${1} ] || [ -z ${2} ] || [ -z ${3} ] || [ -z ${4} ]; then
  echo "🤥 No namespaces specified - please set them 🤥 "
  echo "./set-namespace.sh \$ci_cd_ns \$dev_ns \$test_ns \$staging_ns \$projectmanagement_ns \$cluser_ops_ns"
  echo "For example:"
  echo "./set-namespace.sh my-ci-cd my-dev my-test my-staging my-pm my-cluster-ops"
  exit -1
fi

unameOut="$(uname -s)"
case "${unameOut}" in
    Linux*)     sedargs=-i;;
    Darwin*)    sedargs='-i "" -e';;
    *)          echo "not on Linux or Mac ?" && exit -1
esac

# 🤷‍♀️ bash does stupid things with $sedargs and add escape chars no matter how you set the -i ''  🤷‍♀️
# hence the echo commmand pipe sh to strip it out

echo sed $sedargs "s#\\\"labs-ci-cd\\\"#\\\"${1}\\\"#g" bootstrap/values-bootstrap.yaml | sh
echo sed $sedargs "s#\\\"labs-dev\\\"#\\\"${2}\\\"#g" bootstrap/values-bootstrap.yaml | sh
echo sed $sedargs "s#\\\"labs-test\\\"#\\\"${3}\\\"#g" bootstrap/values-bootstrap.yaml | sh
echo sed $sedargs "s#\\\"labs-staging\\\"#\\\"${4}\\\"#g" bootstrap/values-bootstrap.yaml | sh
echo sed $sedargs "s#\\\"labs-pm\\\"#\\\"${5}\\\"#g" bootstrap/values-bootstrap.yaml | sh
echo sed $sedargs "s#\\\"labs-cluster-ops\\\"#\\\"${6}\\\"#g" bootstrap/values-bootstrap.yaml | sh

echo sed $sedargs "s#labs-test#${2}#g" example-deployment/values-applications.yaml | sh

echo sed $sedargs "s#labs-ci-cd#${1}#g" ubiquitous-journey/values-tooling.yaml | sh

echo sed $sedargs "s#labs-ci-cd#${1}#g" ubiquitous-journey/values-extratooling.yaml | sh
echo sed $sedargs "s#labs-pmd#${5}#g" ubiquitous-journey/values-extratooling.yaml | sh

echo sed $sedargs "s#labs-cluster-ops#${6}#g" ubiquitous-journey/values-day2ops.yaml | sh

echo sed $sedargs "s#labs-ci-cd#${1}#g" argo-app-of-apps.yaml | sh

echo "🐙 All done - happy helming 🐙"
