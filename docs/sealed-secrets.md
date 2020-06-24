## 🕵️‍♀️ Generate Sealed Secrets:
To generate your sealed secret from your secret:

1. Install `kubeseal` using the (instructions)[https://github.com/bitnami-labs/sealed-secrets/releases]
2. Log into the cluster where Sealed Secrets is deployed and take note of the namespace (deaults to `labs-ci-cd`)
3. Process your existing secret eg this nexus secret
```bash
cat << EOF >> /tmp/nexus-password.yaml
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

kubeseal < /tmp/nexus-password.yaml > /tmp/sealed-nexus-password.yaml \
  -n labs-ci-cd \
  --controller-namespace labs-ci-cd \
  --controller-name sealed-secrets \
  -o yaml
```
4. You can now apply that secret straight to the cluster for validation but you _should_ add it in using ArgoCD by committing it to Git :) 
``` bash
cat /tmp/sealed-nexus-password.yaml| oc apply -n labs-ci-cd -f-
```