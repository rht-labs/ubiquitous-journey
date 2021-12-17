# 🦄 Ubiquitous Journey 🔥

🧰 This repo embodies a GitOps approach to deploying application code, middleware infrastructure and supporting CI/CD tools. 🧰

At its simplest, the repo is an [ArgoCD Application](https://argo-cd.readthedocs.io/en/stable/core_concepts/) which references [other helm charts](https://github.com/redhat-cop/helm-charts.git) and [other kustomize definitions](https://github.com/rht-labs/refactored-adventure) to deploy applications.

The idea is to reference other Charts, Kustomize, YAML snippets from within this framework. This keeps things `pluggable` to suit the needs of your team.

🎨 We have evolved the design from the original [Labs CI / CD](https://github.com/rht-labs/labs-ci-cd.git) project. The  Ubiquitous Journey (`UJ`) represents a major milestone in moving to a GitOps approach to tooling, application management and configuration drift using [ArgoCD](https://argoproj.github.io/argo-cd/).

## Components

The folder structure of this repo is split as follows:

```bash
├── archive                            <===  💀 where the skeletons live. archived material.
├── docs                               <===  📖 supporting documentation for UJ.
├── pet-battle                         <===  📖 the example application `pet-battle`
├── templates                          <===  📖 helm templates to create ArgoCD Applications and Projects for UJ
├── ubiquitous-journey                 <===  📖 helm values files containing applications we wish to deploy
├── Chart.yaml                         <===  📖 we deploy UJ using a helm chart
└── values.yaml                        <===  📖 UJ's helm chart values
```

There are two main components to this repository:

1. `Ubiquitous Journey` - Contains all the tools, collaboration software and day2ops to be deployed on Red Hat OpenShift. This includes chat applications, task management apps and tools to support CI/CD workflows and testing. For the complete list and details: [What's in the box?👨](docs/whats-in-the-box.md)
2. An demo application called [`pet-battle`](https://github.com/petbattle) that shows you how to use the UJ structure with a three tiered application stack.

Each part can be used independently of each other but sequentially they create a full stack.

## How do I run it? 🏃‍♀️

If you already have an ArgoCD instance running and you want just want to add the tooling to it, [move to part 2](docs/bootstrap-argocd.md#tooling-for-application-development-🦅) in the docs.

### Prerequisites

You will need:

- OpenShift 4.6+ or greater (cluster admin user required) - [Try OpenShift](https://try.openshift.com)
- Install helm v3+ (cli) or greater - [Helm Quickstart](https://helm.sh/docs/intro/quickstart)

### Let's go, installing ArgoCD 🏃🏻

Install an instance of ArgoCD. There are several methods to install ArgoCD in OpenShift. Pick your favorite flavour 🍦

Use the Red Hat supported GitOps Operator (configured by default as cluster wide and to deploy the operator and an instance in `labs-ci-cd`)

```bash
helm repo add redhat-cop https://redhat-cop.github.io/helm-charts
helm upgrade --install argocd \
  --create-namespace \
  --namespace labs-ci-cd \
  redhat-cop/gitops-operator
```

⛷️ We **strongly** recommend that you make a copy of the `values.yaml` file and make edits that way. This values file can be checked in to this repo and be kept if further changes are needed such as adding in private `repositoryCredentials` or other handy stuff such as `secrets` and `namespaces` etc. For example, you have `argocd-values.yaml` file with your changes:

```bash
helm upgrade --install argocd \
  --create-namespace \
  --namespace labs-ci-cd \
  -f argocd-values.yaml \
  redhat-cop/gitops-operator
```

If you have trouble 😵‍💫 - we have documented some common errors [when installing ArgoCD](docs/argocd-install.md) which may help.

### 🤠 Deploying the Ubiquitous Journey

A handy one liner to deploy all the default software artifacts in this project using their default values. Just make sure the namespace you set below is the same as your ArgoCD namespace from the previous step.

```bash
helm upgrade --install uj --namespace labs-ci-cd .
```

If you login to ArgoCD using the UI here:

```bash
echo https://$(oc get route argocd-server --template='{{ .spec.host }}' -n labs-ci-cd)
```

you should see lots of things spinning up

![argocd-ui](docs/images/argocd-uj.png)

You can set `enabled: true` on all of the application definitions in the `values-*.yaml` files if you want to deploy everything 🧨 .... 💥

Fork the repo and make your changes in the fork if you wish to GitOp enable things. Update the `source` in values.yaml to make sure ArgoCD is pulling from the correct source repo (your fork). If you've already forked the repo and want to deploy quickly you can also run:

```bash
helm upgrade --install uj \
  --set source=https://github.com/<YOUR_FORK>/ubiquitous-journey.git \
  --namespace labs-ci-cd .
```

### Cleanup 🧤

Uninstall and delete all resources in the various projects
```bash
# This may take a while:
helm uninstall uj --namespace labs-ci-cd

# Then remove your ArgoCD instance
helm uninstall argocd
```

### Debugging 🤺

Run the following command to debug one of the UJ values files to see which values are being passed:

```bash
# example debugging the ArgoCD `Application` manifests from the example deployment 
helm install debug --dry-run -f pet-battle/test/values.yaml . 
```
