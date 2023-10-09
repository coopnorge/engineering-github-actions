# engineering-github-actions

Repository to store reusable workflows for github actions

## Workflows

### [release-drafter.yml](./.github/workflows/release-drafter.yml)

This workflow can be used to create a release draft based on the PRs merged since the last release. It will also create a changelog based on the PRs merged.

To use:

1. Create a `.github/workflows/release-drafter.yml` file in your repository
```yaml
name: Release Drafter

on:
    push:
        branches:
            - main
    pull_request:
        types: [open, reopened, synchronize]

permissions:
    contents: read

jobs:
    release-draft:
        steps:
            - uses: actions/checkout@v4
            - uses: coopnorge/engineering-github-actions/.github/workflows/release-drafter.yaml@main
              secrets: inherit
```

2. Create a `.github/release-drafter.yml` file in your repository
```yaml
__extends: coopnorge/engineering-github-actions
```

Alternatively, I would would like to specify your own template for the release notes, you can do so by copying the [default template](https://github.com/coopnorge/engineering-github-actions/.github/release-drafter.yml) and modifying it to your needs.