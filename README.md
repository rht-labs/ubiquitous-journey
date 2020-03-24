# ubiquitous-journey

## What's in the box?

## What it's not...

## How do I run it?

### Bootstrap
```
cd charts/ubiquitous-journey
helm dep up
helm template . | oc apply -f -
```

### Tooling
```
helm template uj -f tooling-values.yaml . | oc apply -f - -n labs-ci-cd
```

## How we work together

## Contributing
