#!/bin/bash
if [ -z ${1} ]; then 
  echo "\n🤥 No namespace prefix specified - using default of 'my'🤥"
fi

NS_PREFIX="${1:-my}"
sed -i '' -e "s#labs-#${NS_PREFIX}-#g" example-deployment/values-applications.yaml
sed -i '' -e "s#labs#${NS_PREFIX}#g" bootstrap/values-bootstrap.yaml
sed -i '' -e "s#labs-#${NS_PREFIX}-#g" ubiquitous-journey/values-tooling.yaml

echo "\n🐙 All done - happy helming 🐙"
