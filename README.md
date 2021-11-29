# 🦄 ubiquitous-journey 🔥

🧰 This repo is an Argo App definition which references [other helm charts](https://github.com/redhat-cop/helm-charts.git). It should not exclusively run Helm Templates but be a more generic Argo App which could reference Kustomize or Operators etc.

🎨 This is the new home for the evolution of what was [Labs CI / CD](https://github.com/rht-labs/labs-ci-cd.git). This project represents a major milestone in moving away from the 3.x OpenShift clusters to a new GitOps approach to tooling, app management and configuration drift using [ArgoCD](https://argoproj.github.io/argo-cd/).

There are two components (one in each folder) to this repository. Each part can be used independently of each other but sequentially they create the full stack. If you already have an ArgoCD instance you want to add the tooling to just [move to part 2](docs/bootstrap-argocd.md#tooling-for-application-development-🦅):
1. Ubiquitous Journey - Contains all the tools, collaboration software and day2ops to be deployed on Red Hat OpenShift. This includes chat applications, task management apps and tools to support CI/CD workflows and testing. For the complete list and details: [What's in the box?👨](docs/whats-in-the-box.md)
2. An example (`pet-battle`) to show how the same structure can be used to implement GitOps for a simple three tiered app stack.

## How do I run it? 🏃‍♀️

### Prereq 
0. OpenShift 4.6 or greater (cluster admin user required) - https://try.openshift.com
1. Install helm v3 (cli) or greater - https://helm.sh/docs/intro/quickstart

Install an instance of ArgoCD. There are several methods to install ArgoCD in OpenShift. Pick your favourite flavour 🍦

1. Use the community Operator for ArgoCD with some defaults to get up and running.
```bash
helm repo add redhat-cop https://redhat-cop.github.io/helm-charts
helm upgrade --install argocd \
  --create-namespace \
  --namespace labs-ci-cd \
  charts/argocd-operator
```

2. Use the Red Hat supported GitOps Operator
```bash
helm repo add redhat-cop https://redhat-cop.github.io/helm-charts
helm upgrade --install argocd \
  --create-namespace \
  --namespace labs-ci-cd \
  redhat-cop/gitops-operator
```

If you use either of the helm approaches, I strongly recommend you get a copy of the `values.yaml` and make edits that way. This values file can be checked in to this repo and be kept if further changes are needed such as adding in private `repositoryCredentials` or other handy stuff. eg
```bash
helm upgrade --install argocd \
  --create-namespace \
  --namespace labs-ci-cd \
  -f argocd-values.yaml \
  charts/argocd-operator
```

3. Go to the Operator Hub on OpenShift and hit install... But remember, you should try to back up the configuration of the ArgoCD Custom Resource instance for repeatability...

#### 🤠 Deploying the Ubiquitous Journey
A handy one liner to deploy all the default software artifacts in this project using their default values. Just make sure the namespace you set below is the same one as where your ArgoCD from the prereqs is running :)
```bash
helm upgrade --install uj --namespace labs-ci-cd .
```

To deploy the whole thing AND the kitchen sink... you can set `enabled: true` on all of the definitions in the `values.yaml` file 🧨 .... 💥

### Cleanup 
Uninstall and delete all resources in the various projects
```bash
helm uninstall uj --namespace labs-ci-cd
```

### Debug
To debug one of the ubiquitous-journey values files, just to see values are passing as expected etc and get a view of what argocd is going to roll out. Run 
```


```


## How can I bring my own tooling?

TODO - add some instructions for adding:
1) new helm charts
2) new Operators etc

## Contributing

## Help

You can find low hanging fruit to help [here](docs/help.md).
