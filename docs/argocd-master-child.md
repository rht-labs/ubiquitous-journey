## ArgoCD Master and Child 👩‍👦

![child-master](images/child-master.png)

1. Deploy a master instance of argocd if you do not already have one. This is deployed into the `master-argocd` project.
```
helm upgrade --install bootstrap -f bootstrap-master/values-bootstrap.yaml bootstrap --create-namespace --namespace labs-bootstrap
```

2. Login to your ArgoCD master and run to create a new project to manage deployments in the Lab's namespace along with the repositories to be allowed pull from:
```bash
argocd login $(oc get route argocd-server --template='{{ .spec.host }}' -n master-argocd):443 --sso --insecure

argocd proj create bootstrap-journey \
  -d https://kubernetes.default.svc,master-argocd \
  -d https://kubernetes.default.svc,labs-ci-cd \
  -d https://kubernetes.default.svc,labs-dev \
  -d https://kubernetes.default.svc,labs-test \
  -d https://kubernetes.default.svc,labs-staging \
  -d https://kubernetes.default.svc,labs-pm \
  -d https://kubernetes.default.svc,labs-cluster-ops \
  -s https://github.com/rht-labs/ubiquitous-journey.git \
  -s https://github.com/rht-labs/refactored-adventure.git \
  -s https://github.com/redhat-cop/helm-charts.git
```

3. You will require elevated permissions in the master argocd project:
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
  --sync-policy automated \
  --path "bootstrap" \
  --values "values-bootstrap.yaml"
```

5. Your new ArgoCD instance should spin up. You can now connect your `ubiquitous-journey` or `example-deployment` to it by following the instructions above.

## Restricted Children

There are two main roles in argocd, the `argocd-server` role is used in the ArgoCD UI, and the `argocd-application-controller` role is used by the server pods:
- oc edit clusterrole argocd-server
- oc edit clusterrole argocd-application-controller

By default we give argocd `cluster-admin` privileges. We usually want this for the `master-argocd` but not for any children argo's such as argocd in the `labs-ci-cd` namespace.
 
The chart supports restricting the `argocd-application-controller` cluster role binding to the default `ClusterRole` installed by the operator which is:
```yaml
kind: ClusterRole
rules:
- apiGroups:
  - '*'
  resources:
  - '*'
  verbs:
  - get
  - list
  - watch
- nonResourceURLs:
  - '*'
  verbs:
  - get
  - list
```

We can set the `namespaceRoleBinding.enabled` flag in Step 4 above, by doing:
```bash
# 4. Create your ArgoCD App for `bootrstrap` in your `master-argocd` namespace and sync it!
argocd app create bootstrap-journey \
  --project bootstrap-journey \
  --dest-namespace master-argocd \
  --dest-server https://kubernetes.default.svc \
  --repo https://github.com/rht-labs/ubiquitous-journey.git \
  --sync-policy automated \
  --path "bootstrap" \
  --helm-set argocd-operator.namespaceRoleBinding.enabled=true \
  --values "values-bootstrap.yaml"
```

We can test that we can't do `cluster-admin` type things (like install cluster operators), for example this will fail:
```bash
oc project labs-ci-cd
argocd login $(oc get route argocd-server --template='{{ .spec.host }}' -n labs-ci-cd):443 --sso --insecure
argocd app create tekton \
  --repo https://github.com/rht-labs/refactored-adventure.git \
  --path tekton/base \
  --dest-server https://kubernetes.default.svc \
  --dest-namespace openshift-operators \
  --revision master \
  --sync-policy automated
```
With an error:
```bash
subscriptions.operators.coreos.com is forbidden: User "system:serviceaccount:labs-ci-cd:argocd-argocd-application-controller" cannot create resource "subscriptions" in API group "operators.coreos.com" in the namespace "openshift-operators"
```

You can install the `tekton` app in the `master-argocd` instance though.

If you restrict the children, you will also want to control which adult users and groups have admin/edit RBAC onto the `master-argocd` and `labs-bootstrap` projects accordingly!
