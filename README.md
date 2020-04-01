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
```
helm template labs -f values-tooling.yaml charts/ubiquitous-journey | oc apply -n labs-ci-cd -f-
```

## How we work together

## Contributing
