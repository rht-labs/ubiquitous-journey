## What's in the box? 👨

- Bootstrap - Create new projects and the rolebinding for groups. See the [bootstrap-project chart](https://github.com/redhat-cop/helm-charts/tree/master/charts/bootstrap-project) for more info. The following are created by default
  - `labs-ci-cd` to house CI/CD tools such as `Jenkins` and `Nexus` etc
  - `labs-dev`,  `labs-test` & `labs-staging` as target namespaces for deploying built artifacts
  - `labs-pm` to house additional tools to help with project management such as `OwnCloud`, `Wekan` and `Mattermost`
  - `labs-cluster-ops` to house cron tasks and other jobs for pruning images and maintaining a healthy platform.
- ArgoCD - Deploys an OpenShift auth enabled Dex Server along with the Operator version of ArgoCD.
- SealedSecrets - Encrypt your Secret into a [SealedSecret](https://github.com/bitnami-labs/sealed-secrets), which is safe to store - even to a public repository. 
- Jenkins - Create new custom Jenkins instance along with all the CoP build agents. See the [Jenkins Chart](https://github.com/redhat-cop/helm-charts/tree/master/charts/jenkins) for more info.
- Nexus - Deploy Nexus along with the OpenShift Plugin. See the [Sonatype Nexus Chart](https://github.com/redhat-cop/helm-charts/tree/master/charts/sonatype-nexus) for more info.
- SonarQube - Deploy SonarQube for static code analysis. See the [Sonarqube Chart](https://github.com/redhat-cop/helm-charts/tree/master/charts/sonarqube) for more info.
- Hoverfly - Deploy Hoverfly for Service Virtualisation. See the [Hoverfly Chart](https://github.com/helm/charts/tree/master/incubator/hoverfly) for more info.
- PactBroker - Deploy PactBroker for Contract Testing. See the [Pact Broker Chart](https://github.com/redhat-cop/helm-charts/tree/master/charts/pact-broker) for more info.
- CodeReadyWorkspaces - Deploy Red Hat CodeReadyWorkspaces for an IDE hosted on OpenShift. See the [CRW Kustomize](https://github.com/rht-labs/refactored-adventure) for more info.
- Zalenium - Deploy Zalenium for Selenium Grid Testing on Kubernetes. See the [Zalenium Chart](https://github.com/zalando/zalenium/tree/master/charts/zalenium) for more info.
- Etherpad - Deploy Etherpad Lite for a real-time collaborative text editor. See [Etherpad Lite](https://github.com/ether/etherpad-lite) for more info.
- Mattermost - Deploy Mattermost Team Edition for team collaboration and messaging See the [Mattermost Chart](https://github.com/mattermost/mattermost-helm) for more info.
- Vault - Deploy Vault to securely store and access your secrets. See the [Vault Chart](https://github.com/hashicorp/vault-helm) for more info.
- Wekan - Deploy Wekan to have collaborative kanban boards. See [Wekan Chart](https://github.com/wekan/wekan) for more info.
- Openshift Pipeline - Deploy Openshift Pipeline for cloud-native CI/CD solution based on the open source Tekton project. See [Tekton Kustomize](https://github.com/rht-labs/refactored-adventure) for more info.
- Owncloud - Deploy Owncloud to document sharing. See [Owncloud Chart](https://github.com/redhat-cop/helm-charts/tree/master/charts/owncloud) for more info.

## What it's not...🤷🏻‍♀️

A collection of different ways to do the same things ie we have taken one tool for one task approach.
For example - Nexus is being used for artifact management. Some teams may use Artifactory, and it should be easily swapped out but we are not demonstrating more than one way to do binary management in this suite of tools.

## Dashboard 📃

The [Developer Experience Dashboard](https://github.com/rht-labs/dev-ex-dashboard) is deployed but requires a `ConfigMap` to be generated once all of the applications have been deployed. For now run this script to generate the config map in the `labs-ci-cd` project:
```bash
bash <(curl -s https://raw.githubusercontent.com/rht-labs/dev-ex-dashboard/master/regenerate-config-map.sh)
```