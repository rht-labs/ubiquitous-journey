#!/bin/bash
# ./set-namespace.sh $ci_cd_namespace $dev_namespace $test_namespace
if [ -z ${1} ] || [ -z ${2} ] || [ -z ${3} ]; then
  echo "🤥 No namespaces specified - please set them 🤥 "
  echo "./set-namespace.sh \$ci_cd_namespace \$dev_namespace \$test_namespace"
  echo "For example:"
  echo "./set-namespace.sh my-ci-cd my-dev my-test"
  exit -1
fi

sed -i '' -e "s#\"labs-ci-cd\"#\"${1}\"#g" bootstrap/values-bootstrap.yaml
sed -i '' -e "s#\"labs-dev\"#\"${2}\"#g" bootstrap/values-bootstrap.yaml
sed -i '' -e "s#\"labs-test\"#\"${3}\"#g" bootstrap/values-bootstrap.yaml

sed -i '' -e "s#labs-dev#${2}#g" example-deployment/values-applications.yaml

sed -i '' -e "s#labs-ci-cd#${1}#g" ubiquitous-journey/values-tooling.yaml

echo "🐙 All done - happy helming 🐙"
