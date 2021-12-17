## Common Errors when installing ArgoCD

If you get an error such as this:

```bash
Error: rendered manifests contain a resource that already exists. Unable to continue with install: Subscription "openshift-gitops-operator" in namespace "openshift-operators" exists and cannot be imported into the current release: invalid ownership metadata;.....
```

when installing argocd; it is because the `openshift-gitops-operator` has already been installed into your cluster.

This means the APIs provided by it (such as `ArgoCD`, `Application`, `ArgoProject` etc) are already available for us to consume. We can update the Cluster instance of ArgoCD to allow it deploy a new ClusterScoped instance to our namespace.

```bash
./patch-gitops-operator.sh labs-ci-cd
```

Then simply run the install command by passing in the parameter `--set operator=null` to the chart to not install the operator but only create an instance in your provided namespace.

OR 

If you have installed the GitOps operator manually by using the Operator Hub and OLM in the OpenShift UIand install via UI, you should store the configuration of the ArgoCD Custom Resource instance definition for repeatability.

You can also edit the subscription manually to enable or disable the default argocd instance and then allow ClusterScoped instances be created in any project.

```yaml
# oc edit subscription/openshift-gitops-operator -n openshift-operators
spec:
  config:
    env:
    - name: DISABLE_DEFAULT_ARGOCD_INSTANCE
      value: "true"
    - name: ARGOCD_CLUSTER_CONFIG_NAMESPACES
      value: labs-ci-cd # YOUR COMMA SEPARATED LIST OF NAMESPACES THAT YOU WANT CLUSTER SCOPED ARGOCD's DEPLOYED IN
  channel: stable
  installPlanApproval: Automatic
  name: openshift-gitops-operator
  source: redhat-operators
  sourceNamespace: openshift-marketplace
```
