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
argocd .....
```

##### deploy using helm ...
```
helm template labs -f values-tooling.yaml --set ci_cd_namespace=labs-ci-cd charts/ubiquitous-journey | oc apply -f -
```

## How we work together

## Contributing
