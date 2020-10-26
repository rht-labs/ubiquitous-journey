# 🦄 ubiquitous-journey 🔥

🧰 This repo is an Argo App definition which references [other helm charts](https://github.com/redhat-cop/helm-charts.git). It should not exclusively run Helm Templates but be a more generic Argo App which could reference Kustomize or Operators etc.

🎨 This is the new home for the evolution of what was [Labs CI / CD](https://github.com/rht-labs/labs-ci-cd.git). This project represents a major milestone in moving away from the 3.x OpenShift clusters to a new GitOps approach to tooling, app management and configuration drift using [ArgoCD](https://argoproj.github.io/argo-cd/).

There are three main components (one in each folder) to this repository. Each part can be used independently of each other but sequentially they create the full stack. If you already have an ArgoCD instance you want to add the tooling to just [move to part 2](docs/bootstrap-argocd.md#tooling-for-application-development-🦅):
1. Bootstrap - Contains references two helm charts used to create and manage projects and deploy ArgoCD
2. Ubiquitous Journey - Contains all the tools, collaboration software and day2ops to be deployed on Red Hat OpenShift. This includes chat applications, task management apps and tools to support CI/CD workflows and testing. For the complete list and details: [What's in the box?👨](docs/whats-in-the-box.md)
3. An example (pet-battle) to show how the same structure can be used to implement GitOps for a simple three tiered app stack.

## How do I run it? 🏃‍♀️

### Prereq 
0. OpenShift 4.3 or greater (cluster admin user required) - https://try.openshift.com
1. Install helm v3 (cli) or greater - https://helm.sh/docs/intro/quickstart
2. Install Argo CD (cli) 1.4.2+ or greater - https://argoproj.github.io/argo-cd/getting_started/#2-download-argo-cd-cli

#### For the impatient 🤠
A handy two liner to deploy all the artifacts in this project using their default values
```bash
# bootstrap to install argocd and create projects
helm template bootstrap --dependency-update -f bootstrap/values-bootstrap.yaml bootstrap | oc apply -f-
# give me ALL THE TOOLS, EXTRAS & OPSY THINGS !
helm template -f argo-app-of-apps.yaml ubiquitous-journey/ | oc -n labs-ci-cd apply -f-
```

### Bootstrap projects and ArgoCD 🍻
If you want to find out all the magic behind, how to override the default values, deploy an example application through ArgoCD and collect metrics, let's meet [here!](docs/bootstrap-argocd.md)🧙‍♀️


### ArgoCD Master and Child 👩‍👦
We can create a master ArgoCD instance in the cluster that can bootstrap other "child" ArgoCD instance(s) for any given project team. This is a good approach if you want each project team to own and operate their own software development tools (jenkins, sonar, argocd, etc) but restrict any elevated permissions they may need e.g.creating argocd Custom Resources Definitions (`CRD's`) or limiting project creation. See [ArgoCD Master and Child Deployment](docs/argocd-master-child.md)

## How can I bring my own tooling?

TODO - add some instructions for adding:
1) new helm charts
2) new Operators etc

## Contributing

## Help

You can find low hanging fruit to help [here](docs/help.md).
