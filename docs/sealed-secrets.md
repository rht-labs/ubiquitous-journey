# Sealed Secrets Help

## 🕵️‍♀️ Generate Sealed Secrets:
To generate your sealed secret from your secret:

1. Install `kubeseal` using the [instructions](https://github.com/bitnami-labs/sealed-secrets/releases)
2. Log into the cluster where Sealed Secrets is deployed and take note of the namespace (deaults to `labs-ci-cd`)
3. Process your existing secret eg this nexus secret using the kubeseal command line. Important to set the correct namespace otherwise the secret will not unseal
```bash
cat << EOF > /tmp/nexus-password.yaml
---
apiVersion: v1
kind: Secret
metadata:
  name: nexus-password
  labels:
    credential.sync.jenkins.openshift.io: "true"
type: "kubernetes.io/basic-auth"
stringData:
  password: "admin123"
  username:  "admin"
EOF
```
```bash
kubeseal < /tmp/nexus-password.yaml > /tmp/sealed-nexus-password.yaml \
  -n labs-ci-cd \
  --controller-namespace labs-ci-cd \
  --controller-name sealed-secrets \
  -o yaml
```
4. You can now apply that secret straight to the cluster for validation but you _should_ add it in using ArgoCD by committing it to Git :) 
``` bash
cat /tmp/sealed-nexus-password.yaml | oc apply -n labs-ci-cd -f-
```
5. Set your UJ Jenkins secrets as follows using the output of the secret generation step
```yaml
jenkins_values: &jenkins_values
  source_secrets: {}
  sealed_secrets:
    - name: git-auth
      password: AgAD+uOI5aCI9YKU2NYt2p7as.....
      username: AgCmeFkNTa0tOvXdI+lEjdJmV5u7FVUcn86SFxiUAF6y.....
```

## 📝 Bring your own certs 
See [the docs written](https://github.com/bitnami-labs/sealed-secrets/blob/master/docs/bring-your-own-certificates.md) by @jtudelag on Sealed Secrets site!
