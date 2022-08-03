# engineering-github-actions

Repository to store reusable workflows for GitHub actions.

## Approve and merge Dependabot PR

[dependabot-approve-and-merge.yaml] is a workflow to automatically approve and
merge Dependabot PRs. This workflow has a limitation at the moment: it will
update **only Docker** images for a given list of images:

- `coopnorge/engineering-docker-images/e0/devtools-terraform-v1beta1`
- `coopnorge/engineering-docker-images/e0/devtools-golang-v1beta1`
- `coopnorge/engineering-docker-images/e0/devtools-kubernetes-v1beta1`
- `coopnorge/engineering-docker-images/e0/poetry-python3.8`
- `coopnorge/engineering-docker-images/e0/poetry-python3.9`
- `coopnorge/engineering-docker-images/e0/poetry-python3.10`.

Check [playbook.internal.coop] for detailed instructions.


[dependabot-approve-and-merge.yaml]: .github/workflows/dependabot-approve-and-merge.yaml
[playbook.internal.coop]: https://playbook.internal.coop
