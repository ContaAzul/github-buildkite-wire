# github-buildkite-wire

Wiring buildkite pipelines to github repos with a single script

## What it does?

1. Creates a pipeline in Builkite that reads for steps on the repo and build only:
   - Commits from master branch;
   - And all PRs, including 3rd parties, then publish commit status;
1. Adds the right Buildkite webhook on the github repo.

## Assumptions

- the name of the pipeline will be the name of the repo;
- the `GITHUB_TOKEN` and `BUILDKITE_TOKEN` have the right permissions;
- you have `curl` and `jq` installed.

## Usage

```console
$ export GITHUB_TOKEN=xyz
$ export BUILDKITE_TOKEN=xpto
$
$ ./setup-pipeline.sh org-or-user repo
```
