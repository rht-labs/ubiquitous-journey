# 🦄 Ubiquitous Journey 🔥

🧰 This repo embodies a GitOps approach to deploying application code, middleware infrastructure and supporting CI/CD tools. 🧰

At its simplest, the repo is an [ArgoCD Application](https://argo-cd.readthedocs.io/en/stable/core_concepts/) which references [other helm charts](https://github.com/redhat-cop/helm-charts.git) and [other kustomize definitions](https://github.com/rht-labs/refactored-adventure) to deploy applications.

The idea is to reference other Charts, Kustomize, YAML snippets from within this framework. This keeps things `pluggable` to suit the needs of your team.

🎨 We have evolved the design from the original [Labs CI / CD](https://github.com/rht-labs/labs-ci-cd.git) project. The  Ubiquitous Journey (`UJ`) represents a major milestone in moving to a GitOps approach to tooling, application management and configuration drift using [ArgoCD](https://argoproj.github.io/argo-cd/).

## Table of Contents

- [Contributor Covenant Code of Conduct](./code-of-conduct.html#contributor-covenant-code-of-conduct)
  * [Our Pledge](./code-of-conduct.html#our-pledge)
  * [Our Standards](./code-of-conduct.html#our-standards)
  * [Our Responsibilities](./code-of-conduct.html#our-responsibilities)
  * [Scope](./code-of-conduct.html#scope)
  * [Enforcement](./code-of-conduct.html#enforcement)
  * [Attribution](./code-of-conduct.html#attribution)
- [🦄 Ubiquitous Journey 🔥](./index.html#%F0%9F%A6%84-ubiquitous-journey-%F0%9F%94%A5)
  * [Components](./index.html#components)
  * [How do I run it? 🏃‍♀️](./index.html#how-do-i-run-it-%F0%9F%8F%83%E2%80%8D%E2%99%80%EF%B8%8F)
    + [Prerequisites](./index.html#prerequisites)
    + [Let's go, installing ArgoCD 🏃🏻](./index.html#lets-go-installing-argocd-%F0%9F%8F%83%F0%9F%8F%BB)
    + [🤠 Deploying the Ubiquitous Journey](./index.html#%F0%9F%A4%A0-deploying-the-ubiquitous-journey)
    + [Cleanup 🧤](./index.html#cleanup-)
    + [Debugging 🤺](./index.html#debugging-)
- [Common Errors when installing ArgoCD](./docs%2Fargocd-install.html#common-errors-when-installing-argocd)
- [ArgoCD Master and Child 👩‍👦](./docs%2Fargocd-master-child.html#argocd-master-and-child-%F0%9F%91%A9%E2%80%8D%F0%9F%91%A6)
- [Restricted Children](./docs%2Fargocd-master-child.html#restricted-children)
- [Bootstrap projects and ArgoCD 🍻](./docs%2Fbootstrap-argocd.html#bootstrap-projects-and-argocd-%F0%9F%8D%BB)
  * [Tooling for Application Development 🦅](./docs%2Fbootstrap-argocd.html#tooling-for-application-development-%F0%9F%A6%85)
      - [(A) Deploy using argo app of apps ...](./docs%2Fbootstrap-argocd.html#a-deploy-using-argo-app-of-apps-)
      - [(B) Deploy using helm ...](./docs%2Fbootstrap-argocd.html#b-deploy-using-helm-)
- [Example Application Deploy 🌮](./docs%2Fbootstrap-argocd.html#example-application-deploy-%F0%9F%8C%AE)
- [Cleaning up ArgoCD Apps 🧹](./docs%2Fbootstrap-argocd.html#cleaning-up-argocd-apps-%F0%9F%A7%B9)
- [Metrics 📉](./docs%2Fbootstrap-argocd.html#metrics-%F0%9F%93%89)
- [Deploy to a custom namespace 🦴](./docs%2Fdeploy-custom-namespace.html#deploy-to-a-custom-namespace-%F0%9F%A6%B4)
- [Help me](./docs%2Fhelp.html#help-me)
  * [Not automated yet ...](./docs%2Fhelp.html#not-automated-yet-)
- [Sealed Secrets Help](./docs%2Fsealed-secrets.html#sealed-secrets-help)
  * [🕵️‍♀️ Generate Sealed Secrets:](./docs%2Fsealed-secrets.html#%F0%9F%95%B5%EF%B8%8F%E2%80%8D%E2%99%80%EF%B8%8F-generate-sealed-secrets)
  * [📝 Bring your own certs](./docs%2Fsealed-secrets.html#%F0%9F%93%9D-bring-your-own-certs)
- [What's in the box? 👨](./docs%2Fwhats-in-the-box.html#whats-in-the-box-%F0%9F%91%A8)
- [What it's not...🤷🏻‍♀️](./docs%2Fwhats-in-the-box.html#what-its-not%F0%9F%A4%B7%F0%9F%8F%BB%E2%80%8D%E2%99%80%EF%B8%8F)
- [Dashboard 📃](./docs%2Fwhats-in-the-box.html#dashboard-%F0%9F%93%83)

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
helm delete uj --namespace labs-ci-cd

# Then remove your ArgoCD instance
helm delete argocd --namespace labs-ci-cd
```

### Debugging 🤺

Run the following command to debug one of the UJ values files to see which values are being passed:

```bash
# example debugging the ArgoCD `Application` manifests from the example deployment 
helm install debug --dry-run -f pet-battle/test/values.yaml . 
```
