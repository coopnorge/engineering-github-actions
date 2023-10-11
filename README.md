# engineering-github-actions

Repository to store reusable workflows for github actions

## Workflows

### [release-drafter.yml](./.github/workflows/release-drafter.yml)

This workflow can be used to create a release draft based on the PRs since the last release. It will also create a changelog based on the PRs merged.

To use:

1. Create a `.github/workflows/release-drafter.yml` file in your repository
```yaml
name: Release Drafter
on:
  push:
    branches:
      - main
  pull_request:
    types:
      - opened
      - reopened
      - synchronize
      - edited
permissions:
  contents: read
jobs:
  release-draft:
    permissions:
      pull-requests: write
      contents: write
    uses: >-
      coopnorge/engineering-github-actions/.github/workflows/release-drafter.yaml@main
    secrets: inherit
```

2. **OPTIONAL:** Create a `.github/release-drafter.yml` file in your repository.
Copy the [default configuration](https://github.com/coopnorge/.github/blob/main/.github/release-drafter.yml) and modify it to your needs.

** NOTE: ** Although it is possible to have different format for release drafts. It is recommended to use the default format to ensure consistency across repositories. If you have any suggestion on how the release should look like please open an issue.