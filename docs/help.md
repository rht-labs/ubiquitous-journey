## Help me 

### Not automated yet ...

 - [ ]  Create ArgoCD token in UI or on CMD Line. Update config map to give `apiKey` capability to the admin account. Then generate token (ui or cli). Use `basic-auth` secret type with `username: token` and `password: aaa.bbb.ccc` as Jenkins will give you a JSON object if you just use `opaque`. This way you get the vars `ARGOCD_CREDS_PSW` and you're away. Note ArgoCD Admin passwd is now stored in a secret called 

```bash
$ oc edit cm argocd-cm

data:
  accounts.admin: apiKey

$ argocd account generate-token --account admin
```

- [ ] `dummy-sa` should become `jenkins` :wink:

- [ ] Generate GITHUB personal access token or whatever to be able to push git updates as part of jenkins workflow
