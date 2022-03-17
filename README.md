# engineering-github-actions

Repository to store reusable workflows for github actions.

## Reusable workflows

Read more about how to write and use reusable workflows [here](https://docs.github.com/en/actions/using-workflows/reusing-workflows).

## Using a reusable workflow

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
