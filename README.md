# Generate / Update CONTRIBUTORS File - GitHub Action

This GitHub Action updates a CONTRIBUTORS file with the top contributors from the specified project, pulling contents from the GitHub API.

## Example Usage

```
name: Update CONTRIBUTORS file
on:
  schedule:
    - cron: "0 * * * *"
  workflow_dispatch:
jobs:
  main:
    runs-on: ubuntu-latest
    steps:
      - uses: minicli/action-contributors@v1
        name: 'Update a projects CONTRIBUTORS file'
        env:
          CONTRIB_REPOSITORY: 'minicli/minicli'
          CONTRIB_OUTPUT_FILE: 'CONTRIBUTORS.md'
```

