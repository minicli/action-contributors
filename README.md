# Generate / Update CONTRIBUTORS File - GitHub Action

This GitHub Action updates a CONTRIBUTORS file with the top contributors from the specified project, pulling contents from the GitHub API.

## Example Usage

This action is made to use in conjunction with [test-room-7/action-update-file](https://github.com/marketplace/actions/update-files-on-github) in order to automatically commit an updated CONTRIBUTORS file in a fixed interval.

The following example sets a workflow to update the file once a month:

```
name: Update CONTRIBUTORS file
on:
  schedule:
    - cron: "0 0 0 0 *"
  workflow_dispatch:
jobs:
  main:
    runs-on: ubuntu-latest
    steps:
      - uses: minicli/action-contributors@v1
        name: 'Update a projects CONTRIBUTORS file'
      - name: Update resources
        uses: test-room-7/action-update-file@v1
        with:
          file-path: 'CONTRIBUTORS.md'
          commit-msg: Update Contributors
          github-token: ${{ secrets.GITHUB_TOKEN }}
        env:
          CONTRIB_REPOSITORY: 'minicli/minicli'
          CONTRIB_OUTPUT_FILE: 'CONTRIBUTORS.md'
```

