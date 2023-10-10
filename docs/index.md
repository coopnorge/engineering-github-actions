# Github workflow to create a release draft based on the PRs since the last release (release-drafter.yaml)

This workflow will create a release draft based on the PRs merged since the last release. It will also create a changelog based on the PRs merged.

This workflow will also try to assign labels to PR based on the title of the PR. The labels is defined [here](https://github.com/coopnorge/.github/blob/main/.github/release-drafter.yml)

## Usage

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

## How it works

When a PR is created, this workflow will check the PR title and try to assign labels to the PR based on the title. If you do not agree with the labels assigned you can assign new labels yourself.

Supported labels for version bumping:

```
- "patch" # bump 0.0.X
- "minor" # bump 0.X.0
- "major" # bump X.0.0
```

Supported labels to help with changelog grouping:
  
```
- "dependency"
- "chore"
- "enhancements"
- "bug-fix"
- "deprecation"
- "breaking-change"
```

After you have merged the PR, the draft release will be created/updated. The draft release will be based on the PRs merged since the last release. The draft release will also contain a changelog based on the PRs merged.

When you are ready to release, you can publish the release draft. This will create a new release and tag the release with the version number.