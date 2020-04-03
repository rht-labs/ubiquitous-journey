# 🦄 ubiquitous-journey 🔥 

🧰 This repo is an Argo App definition which references [other charts](https://github.com/rht-labs/charts.git). It should not exclusively run Helm Templates but be a more generic Argo App which could reference Kustomize or Operators etc.

🎨 This is the new home for the evolution of what was [Labs CI / CD](https://github.com/rht-labs/labs-ci-cd.git). This project represents a majour milestone in moving away from the 3.x OpenShift clusters to a new GitOps approach to tooling, app management and configuration drift using [ArgoCD](https://argoproj.github.io/argo-cd/).

## What's in the box? 👨

- Bootstrap - TODO. Ref the chart in rht-labs
- ArgoCD - TODO. Ref the chart in tylerland?
- Jenkins - TODO. Ref the chart in rht-labs
- Nexus - TODO. Ref the chart in rht-labs
- SonarQube - TODO. Ref the chart in rht-labsbs
- Hoverfly - TODO. Ref the chart in rht-labs
- PactBroker - TODO. Ref the chart in rht-labs
- CodeReadyWorkspaces - TODO. Ref the kustomize operator in rht-labs

## What it's not...🤷🏻‍♀️

A collection of different ways to do the same things ie we have taken one tool for one task approach.
For example - Nexus is being used for artifact management. Some teams may use Artifactory, and it should be easily swapped out but we are not demonstrating more than one way to do binary management in this suite of tools.

## How do I run it?

### Prereq 
0. OpenShift 4.3 or greater - https://try.openshift.com
1. Install helm v3 or greater - https://helm.sh/docs/intro/quickstart
2. Install Argo CD (cli) 1.4.2+ or greater - https://argoproj.github.io/argo-cd/getting_started/#2-download-argo-cd-cli

### Bootstrap 🍻
Create your Labs's CI/CD, Dev and Test namespaces. Fill them with service accounts and normal role bindings as defined in the [bootstrap project helm chart](https://github.com/rht-labs/charts/blob/master/charts/bootstrap-project/values.yaml). Over ride them by updating any of the values in `bootstrap/values-bootstrap.yaml` before running `helm template`

1. Bring down the chart dependencies:
```
helm dep up bootstrap
```
2. Install your chart and argo. NOTE - this currently will deploy ARGO into whatever namespace you're currently in. TODO - fix this. Work around, run `oc new-project labs-ci-cd` then execute this:
```
helm template labs -f bootstrap/values-bootstrap.yaml bootstrap | oc apply -f-
```

### Tooling

##### Deploy using argo app of apps ...
See: [ArgoCD App of Apps approach](https://argoproj.github.io/argo-cd/operator-manual/declarative-setup/#app-of-apps)

```
argocd login --grpc-web $(oc get routes labs-argocd-server -o jsonpath='{.spec.host}')
argocd app create stuff \
    --dest-namespace labs-ci-cd \
    --dest-server https://kubernetes.default.svc \
    --repo https://github.com/rht-labs/ubiquitous-journey.git \
    --path "ubiquitous-journey" --values "values-tooling.yaml"
argocd app sync stuff
```

##### Deploy using helm ...
```
helm template labs -f argo-app-of-apps.yaml ubiquitous-journey/ | oc apply -f -
```
If you wish to use a different project to `labs-ci-cd` for example `mymproject` try:
```
helm template labs -f argo-app-of-apps.yaml --set applications[0].destination=myproject ubiquitous-journey/ | oc apply -f -
```

#### Create my own namespaced version of all the tools
Because this is GitOps to make changes to the namespaces etc they should really be committed to git.... For example, if you wanted to create a `my-ci-cd` for all teh tooling to be deployed to, the steps are simple. Fork this repo and make the following changes there
1. Edit `bootstrap/values-tooling.yaml` and update the `prefix: my`
2. Run
```
helm template labs -f bootstrap/values-bootstrap.yaml bootstrap | oc apply -f-
```
3. Edit `ubiquitous-journey/values-tooling.yaml` and update the `destination: &ci_cd_ns my-ci-cd`
4. Commit this change to your fork of the repo.
5. Run argo create app replacing `MY_FORK` as appropriate
```
argocd app create stuff \
    --dest-namespace my-ci-cd \
    --dest-server https://kubernetes.default.svc \
    --repo https://github.com/MY_FORK/ubiquitous-journey.git \
    --path "ubiquitous-journey" --values "values-tooling.yaml"
```

## How can I bring my own tooling?

TODO - add some instructions for adding:
1) new helm charts
2) new Operators etc

## Contributing
