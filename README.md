# zot-chart
Zot Chart with no stateful set and correct status probe urls

# Version numbers
We are versioning the chart based on our backports. We are starting with their
version number and incrementing the `hh-1` suffix anytime we have to add more
back ports, so `--version v0.1.67-hh1` represents our initial commit. The `--app-version` 
in the chart will align with the zot binary that we are using this chart with.

## Destination URI

The justfile is setup to push to `fabricator/charts/zot` just as the previous
version did. The URI doesn't match the name of this repo, this is because zot
is in the bootstrapping for fabricator, so it gets special treatment.

## Local build and push

local development assumes the presence of a running zot registry that is setup
to mirror the hedgehog ghcr.io registry.
sequence:
1. `just helm-lint`
1. `just helm-package`
1. `just local-push`

## CI build and push

1. `just push-chart`
1. `just push-airgap`

