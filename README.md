# Generate / Update CONTRIBUTORS File - GitHub Action

This GitHub Action updates a CONTRIBUTORS file with the top contributors from the specified project, pulling contents from the GitHub API.

## Example Usage

This action is made to use in conjunction with [test-room-7/action-update-file](https://github.com/marketplace/actions/update-files-on-github) in order to automatically commit an updated CONTRIBUTORS file in a fixed interval.

The following example sets a workflow to update the file once a month, committing the changes directly to the main project's branch:

```yaml
name: Update CONTRIBUTORS file
on:
  schedule:
    - cron: "0 0 1 * *"
  workflow_dispatch:
jobs:
  main:
    runs-on: ubuntu-latest
    steps:
      - uses: minicli/action-contributors@v3
        name: "Update a projects CONTRIBUTORS file"
      - name: Commit changes
        uses: test-room-7/action-update-file@v1
        with:
          file-path: 'CONTRIBUTORS.md'
          commit-msg: Update Contributors
          github-token: ${{ secrets.GITHUB_TOKEN }}
        env:
          CONTRIB_REPOSITORY: 'minicli/minicli'
          CONTRIB_OUTPUT_FILE: 'CONTRIBUTORS.md'
```


You need to replace the `CONTRIB_REPOSITORY` value with the GitHub project you want to pull contributors from.

If you'd prefer to create a pull request instead of committing the changes directly to the main branch, 
you can use the [create-pull-request](https://github.com/marketplace/actions/create-pull-request) action instead. That will require also the [actions/checkout](https://github.com/actions/checkout) GitHub action.

```yaml
name: Update CONTRIBUTORS file
on:
  schedule:
    - cron: "0 0 1 * *"
  workflow_dispatch:
jobs:
  main:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: minicli/action-contributors@v3
        name: "Update a projects CONTRIBUTORS file"
      - name: Create a PR
        uses: peter-evans/create-pull-request@v3
        with:
          commit-message: Update Contributors
          title: "[automated] Update Contributors File"
          token: ${{ secrets.GITHUB_TOKEN }}
        env:
          CONTRIB_REPOSITORY: 'minicli/minicli'
          CONTRIB_OUTPUT_FILE: 'CONTRIBUTORS.md'
```