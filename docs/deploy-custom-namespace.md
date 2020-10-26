## Deploy to a custom namespace 🦴
Because this is GitOps to make changes to the namespaces etc, they should really be committed to git! For example, if you wanted to create a `my-ci-cd` namespace for all the tooling to be deployed to, the steps are simple. Fork this repo and make the following changes there:

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

5. Login to ArgoCD as described in [Tooling](bootstrap-argocd.md) section.

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