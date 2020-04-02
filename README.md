# ubiquitous-journey

## What's in the box?

## What it's not...

## How do I run it?

### Bootstrap
```
helm dep up charts/ubiquitous-journey
helm template labs -f values-bootstrap.yaml --namespace labs-ci-cd charts/ubiquitous-journey | oc apply -f-
```

### Tooling


##### deploy using argo app ...
```
argocd login <route>
argocd app create stuff \
    --dest-namespace labs-ci-cd \
    --dest-server https://kubernetes.default.svc \
    --repo https://github.com/ckavili/ubiquitous-journey.git \
    --path "charts/ubiquitous-journey" --values "values-tooling.yaml"
argocd app sync stuff 
```

##### deploy using helm ...
```
helm template labs -f values-tooling.yaml --set ci_cd_namespace=labs-ci-cd charts/ubiquitous-journey | oc apply -f -
```

## How we work together

## Contributing
