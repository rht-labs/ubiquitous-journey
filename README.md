# 🦄 ubiquitous-journey 🔥

🧰 This repo is an Argo App definition which references [other helm charts](https://github.com/redhat-cop/helm-charts.git). It should not exclusively run Helm Templates but be a more generic Argo App which could reference Kustomize or Operators etc.

🎨 This is the new home for the evolution of what was [Labs CI / CD](https://github.com/rht-labs/labs-ci-cd.git). This project represents a major milestone in moving away from the 3.x OpenShift clusters to a new GitOps approach to tooling, app management and configuration drift using [ArgoCD](https://argoproj.github.io/argo-cd/).

There are three main components (one in each folder) to this repository. Each part can be used independently of each other but sequentially they create the full stack. If you already have an ArgoCD instance you want to add the tooling to just [move to part 2](#tooling-for-application-development):
1. Bootstrap - Contains references two helm charts used to create and manage projects and deploy ArgoCD
2. Ubiquitous Journey - Contains all the tools and collaboration software to be deployed on Red Hat OpenShift. This includes chat applications, task management apps and tools to support CI/CD workflows and testing.
3. An example (pet-battle) to show how the same structure can be used to implement GitOps for a simple three tiered app stack.

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
- Zalenium - Deploy Zalenium for Selenium Grid Testing on Kubernetes. See the [Zalenium Chart](https://github.com/ckavili/zalenium) for more info.
- Etherpad - Deploy Etherpad Lite for a real-time collaborative text editor. See [Etherpad Lite](https://github.com/ether/etherpad-lite) for more info.
- Mattermost - Deploy Mattermost Team Edition for team collaboration and messaging See the [Mattermost Chart](https://github.com/mattermost/mattermost-helm) for more info.
- Vault - Deploy Vault to securely store and access your secrets. See the [Vault Chart](https://github.com/hashicorp/vault-helm) for more info.
- Wekan - Deploy Wekan to have collaborative kanban boards. See [Wekan Chart](https://github.com/wekan/wekan) for more info.
- Openshift Pipeline - Deploy Openshift Pipeline for cloud-native CI/CD solution based on the open source Tekton project. See [Tekton Kustomize](https://github.com/rht-labs/refactored-adventure) for more info.
- Owncloud - Deploy Owncloud to document sharing. See [Owncloud Chart](https://github.com/redhat-cop/helm-charts/tree/master/charts/owncloud) for more info.


## What it's not...🤷🏻‍♀️

A collection of different ways to do the same things ie we have taken one tool for one task approach.
For example - Nexus is being used for artifact management. Some teams may use Artifactory, and it should be easily swapped out but we are not demonstrating more than one way to do binary management in this suite of tools.

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
![bootstrap-uj](docs/images/bootstrap-uj.png)

The `bootstrap` helm chart will create your **Labs's CI/CD**, **Dev**, **Test** and **Staging** namespaces. Fill them with service accounts and normal role bindings as defined in the [bootstrap project helm chart](https://github.com/redhat-cop/helm-charts/blob/master/charts/bootstrap-project/values.yaml). You can override them by updating any of the values in `bootstrap/values-bootstrap.yaml` before running `helm template`.
It will also deploy an ArgoCD Instance into one of these namespaces (default to `labs-ci-cd`) along with an instance of Sealed Secrets by Bitnami if enabled (default disabled).

If you want to override namespaces see [Deploy to a custom namespace](#deploy-to-a-custom-namespace).

1. Bring down the chart dependencies and install `bootstrap` helm chart in a sweet oneliner 🍾:
```bash
helm template bootstrap --dependency-update  -f bootstrap/values-bootstrap.yaml bootstrap | oc apply -f -
```

2. Because this is GitOps we should manage the config of these roles, projects and ArgoCD itself by adding it to our newly created ArgoCD instance. This means all future changes to these can be tracked and managed in Git! Login to Argo and run the following command.

To login with argocd from CLI using sso:
```bash
argocd login $(oc get route argocd-server --template='{{ .spec.host }}' -n labs-ci-cd):443 --sso --insecure
```
else if no sso:
```bash
argocd login --grpc-web $(oc get routes argocd-server -o jsonpath='{.spec.host}' -n labs-ci-cd) --insecure
```

Finally create the Argo app `bootstrap-journey`:
```bash
argocd app create bootstrap-journey \
    --dest-namespace labs-ci-cd \
    --dest-server https://kubernetes.default.svc \
    --repo https://github.com/rht-labs/ubiquitous-journey.git \
    --path "bootstrap" --values "values-bootstrap.yaml"
```

By default the ArgoCD service account use Cluster wide RoleBindings. Namespace control can be restricted in the bootstrap values. This will prevent certain actions by ArgoCD (e.g. operator CRD deployments) and not all of the listed applications may work (e.g. Tekton, CRW):
```
  # argocd rbac only in listed namespaces
  namespaceRoleBinding:
    enabled: true
    namespaces:
    - name: *ci_cd
    - name: *dev
    - name: *test
    - name: *stage
```

### Tooling for Application Development 🦅
![ubiquitous-journey](docs/images/ubiquitous-journey.png)

Our standard approach is to deploy all the tooling to the `labs-ci-cd` namespace. There are two ways you can deploy this project - as an Argo App of Apps or a helm3 template.

##### (A) Deploy using argo app of apps ...
See: [ArgoCD App of Apps approach](https://argoproj.github.io/argo-cd/operator-manual/declarative-setup/#app-of-apps)
* Deploy the base tooling for building out CI/CD pipelines
```bash
argocd app create ubiquitous-journey \
    --dest-namespace labs-ci-cd \
    --dest-server https://kubernetes.default.svc \
    --repo https://github.com/rht-labs/ubiquitous-journey.git \
    --path "ubiquitous-journey" --values "values-tooling.yaml"
argocd app sync ubiquitous-journey
```

* There is a separate set of tools which can also be added to your stack. These include some project management and supplimental things such as `Wekan` or `Mattermost`. By default they will be deployed to the `lab-pm` project. To create these run the following commmand:
```bash
argocd app create uj-extras \
    --dest-namespace labs-ci-cd \
    --dest-server https://kubernetes.default.svc \
    --repo https://github.com/rht-labs/ubiquitous-journey.git \
    --path "ubiquitous-journey" --values "values-extratooling.yaml"
argocd app sync uj-extras
```

* Deploy `day2ops` tasks to monitor and audit the cluster
```bash
argocd app create uj-day2ops \
    --dest-namespace my-ci-cd \
    --dest-server https://kubernetes.default.svc \
    --repo https://github.com/MY_FORK/ubiquitous-journey.git \
    --path "ubiquitous-journey" --values "values-day2ops.yaml"
argocd app sync uj-day2ops
```


##### (B) Deploy using helm ...
```bash
helm template labs -f argo-app-of-apps.yaml ubiquitous-journey/ | oc apply -f -
```

## Deploy to a custom namespace 🦴
Because this is GitOps to make changes to the namespaces etc they should really be committed to git.... For example, if you wanted to create a `my-ci-cd` namespace for all the tooling to be deployed to, the steps are simple. Fork this repo and make the following changes there:

1. Run `set-namespace.sh $ci_cd $dev $test $staging` where `$ci_cd $dev $test $staging` are the namespaces you would like to bootstrap eg `./set-namespace.sh my-ci-cd my-dev my-test my-staging`. This will update the following files: 
* `bootstrap/values-bootstrap.yaml`: the `ci_cd_namespace` and argocd namespace `namespace: "my-ci-cd"`.
* `ubiquitous-journey/values-tooling.yaml`: the `destination: &ci_cd_ns my-ci-cd`
* `example-deployment/values-applications.yaml`: the `destination: &ci_cd_ns my-dev`
* `argo-app-of-apps.yaml`: the `destination: my-ci-cd`

2. Manually update `argo-app-of-apps.yaml` to point `source:` to `MY FORK` instead of `rht-labs`. Update the branch from `master` to your `branchname` if you are not on master in your fork.

3. 🌈If there is more than one ArgoCD instance in your cluster, update `instancelabel` parameter to a unique value in `bootstrap/values-bootstrap.yaml` file.
e.g: `instancelabel: mycompany.com/myapps`

4. Git commit this change to your fork and run the following Helm Command:
```bash
helm template bootstrap --dependency-update -f bootstrap/values-bootstrap.yaml bootstrap   | oc apply -f -
```
_FYI if you're feeling lazy, you can override the values on the commandline directly but rememeber - this is GitOps 🐙! So don't do that please 😇_

5. Login to ArgoCD as described in [Tooling](#Tooling) section.

6. Run argo create app replacing `MY_FORK` as appropriate
```bash
argocd app create ubiquitous-journey \
    --dest-namespace my-ci-cd \
    --dest-server https://kubernetes.default.svc \
    --repo https://github.com/MY_FORK/ubiquitous-journey.git \
    --path "ubiquitous-journey" --values "values-tooling.yaml"
argocd app sync ubiquitous-journey
```
Or if you're using just helm3 cli to instead of `argocd` cli
```
helm template -f argo-app-of-apps.yaml ubiquitous-journey/ | oc apply -f -
```

If you're looking to deploy the extra tooling too, the command is the same as above but pointing to the correct project:
```bash
argocd app create uj-extras \
    --dest-namespace my-ci-cd \
    --dest-server https://kubernetes.default.svc \
    --repo https://github.com/MY_FORK/ubiquitous-journey.git \
    --path "ubiquitous-journey" --values "values-extratooling.yaml"
argocd app sync uj-extras
```

7. Deploy `day2ops` tasks to monitor and audit the cluster
```bash
argocd app create uj-day2ops \
    --dest-namespace my-ci-cd \
    --dest-server https://kubernetes.default.svc \
    --repo https://github.com/MY_FORK/ubiquitous-journey.git \
    --path "ubiquitous-journey" --values "values-day2ops.yaml"
argocd app sync uj-day2ops
```

## Example Application Deploy 🌮
![example-app](docs/images/example-app.png)

Deploy the example app `pet-battle` using GitOps! This example project serves as a reference of how you could deploy an application as an App of Apps. The app is pre-built and hosted on quay. After you deploy the application for the first time update the `app_tag` to `purple` in `example-deployment/values-applications.yaml` and commit the changes to see GitOps in action!

Create using helm:
```bash
helm template catz -f example-deployment/values-applications.yaml example-deployment/ | oc apply -n labs-ci-cd -f -
```
or using argocd:
```bash
argocd app create catz \
    --dest-namespace labs-ci-cd \
    --dest-server https://kubernetes.default.svc \
    --repo https://github.com/rht-labs/ubiquitous-journey.git \
    --path "example-deployment" --values "values-applications.yaml"
argocd app sync catz
```

## ArgoCD Master and Child 👩‍👦
![child-master](docs/images/child-master.png)

We can create a master ArgoCD instance in the cluster that can bootstrap other "child" ArgoCD instance(s) for any given project team. This is a good approach if you want each project team to own and operate their own software development tools (jenkins, sonar, argocd, etc) but restrict any elevated permissions they may need e.g.creating argocd Custom Resources Definitions (`CRD's`) or limiting project creation.

1. Deploy a master instance of argocd if you do not already have one. This is deployed into the `master-argocd` project.
```
helm template --dependency-update -f bootstrap-master/values-bootstrap.yaml bootstrap-master | oc apply -f -
```

2. Login to your ArgoCD master and run to create a new project to manage deployments in the Lab's namespace along with the repositories to be allowed pull from:
```bash
argocd login $(oc get route argocd-server --template='{{ .spec.host }}' -n master-argocd):443 --sso --insecure

argocd proj create bootstrap-journey \
    -d https://kubernetes.default.svc,master-argocd \
    -d https://kubernetes.default.svc,labs-ci-cd \
    -d https://kubernetes.default.svc,labs-dev \
    -d https://kubernetes.default.svc,labs-test \
    -s https://github.com/rht-labs/ubiquitous-journey.git \
    -s https://github.com/rht-labs/refactored-adventure.git \
    -s https://github.com/redhat-cop/helm-charts.git
```

3. If you require elevated permissions such as project create etc:
```bash
argocd proj allow-cluster-resource bootstrap-journey "*" "*"
```

4. Create your ArgoCD App for `bootrstrap` in your `master-argocd` namespace and sync it!
```bash
argocd app create bootstrap-journey \
    --project bootstrap-journey \
    --dest-namespace master-argocd \
    --dest-server https://kubernetes.default.svc \
    --repo https://github.com/rht-labs/ubiquitous-journey.git \
    --path "bootstrap" --values "values-bootstrap.yaml"
argocd app sync bootstrap-journey
```

4. Your new ArgoCD instance should spin up. You can now connect your `ubiquitous-journey` or `example-deployment` to it by following the instructions above

## Cleaning up ArgoCD Apps 🧹
Sometime ArgoCD `Application` CRs can get stuck after they've been deleted and cause funky issues.
This is particularly annoying while testing with multiple ArgoCD instances.
To *force delete* the application CRs run the `force-delete-application-cr.sh` script pointing to the namespace your `Application` CRs are stored. This will remove the `Finalizers`.
```bash
oc login ...
./force-delete-application-cr.sh labs-ci-cd
```

## How can I bring my own tooling?

TODO - add some instructions for adding:
1) new helm charts
2) new Operators etc

## Metrics 📉

By setting `argocd.metrics.enabled: true` in `values-bootstrap.yaml`, promethus and grafana are deployed by the operator to capture argocd metrics.

An example of the latest grafana dashboard for argocd is available here
- https://raw.githubusercontent.com/argoproj/argo-cd/master/examples/dashboard.json

## Dashboard 📃

The [Developer Experience Dashboard](https://github.com/rht-labs/dev-ex-dashboard) is deployed but requires a `ConfigMap` to be generated once all of the applications have been deployed. For now run this script to generate the config map in the `labs-ci-cd` project:
```bash
bash <(curl -s https://raw.githubusercontent.com/rht-labs/dev-ex-dashboard/master/regenerate-config-map.sh)
```

## Contributing

## Help

You can find low hanging fruit to help [here](docs/help.md).
