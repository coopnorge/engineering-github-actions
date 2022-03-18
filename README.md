# engineering-github-actions

Repository to store reusable workflows for github actions.

## Actions

Read more about how to write and use custom actions on
[Github's documentation for Custom Actions](https://docs.github.com/en/actions/creating-actions/about-custom-actions).

For specifically how the `actions.yaml` syntax looks like, see
[the "Metadata syntax" section of Github's docs](https://docs.github.com/en/actions/creating-actions/metadata-syntax-for-github-actions).

### Docker actions

Passing build arguments to the Docker image that is created or the action is
[currently not possible](https://github.community/t/feature-request-build-args-support-in-docker-container-actions/16846).
The suggested work-around
[is to use a bootstrapping image to build your desired image](https://github.community/t/feature-request-build-args-support-in-docker-container-actions/16846/6).

## Workflows

Read more about how to write and use reusable workflows on
[Github's documentation for "Reusing workflows"](https://docs.github.com/en/actions/using-workflows/reusing-workflows).
For specifically the workflow YAML syntax, see
[the "Workflow syntax" section of Github's docs](https://docs.github.com/en/actions/using-workflows/workflow-syntax-for-github-actions).

### Using a reusable workflow

To use the `go-library` workflow in your own workflow, include it as a `uses`
job.

Using the `go-library` workflow as an example:

```yaml
jobs:
  check_test_and_build:
    uses: coopnorge/engineering-github-actions/.github/workflows/go-library.yaml@{ref}
    with:
      GOBIN:
  do_more_stuff:
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-go@v2
      - run: go -do "more stuff"
```

`{ref}` in this case is a git reference, meaning a commit SHA, a branch name or
a tag.
