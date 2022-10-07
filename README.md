# Generate / Update CONTRIBUTORS File - GitHub Action

This GitHub Action updates a CONTRIBUTORS file with the top contributors from the specified project, pulling contents from the GitHub API. You can use it in combination with an action to push changes directly into your project's main branch, or with an action that creates a PR with the updated file.

### Supported Configuration via Environment Variables:

- CONTRIB_REPOSITORY: The repository you want to pull contributors from. This is mandatory.
- CONTRIB_OUTPUT_FILE: The file you want to generate, default set to `CONTRIBUTORS.md`.
- CONTRIB_TEMPLATE: The [stencil](https://github.com/minicli/stencil) template to use - you can use this to customize the generated markdown file. Default set to the included `contributors.tpl` file.
- CONTRIB_IGNORE: A comma-separated string with users to ignore. Default set to `github-actions[bot],renovate-bot,dependabot`.

## Basic Usage

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
      - uses: minicli/action-contributors@v3.2.1
        name: "Update a projects CONTRIBUTORS file"
        env:
          CONTRIB_REPOSITORY: 'minicli/minicli'
          CONTRIB_OUTPUT_FILE: 'CONTRIBUTORS.md'
      - name: Commit changes
        uses: test-room-7/action-update-file@v1
        with:
          file-path: 'CONTRIBUTORS.md'
          commit-msg: Update Contributors
          github-token: ${{ secrets.GITHUB_TOKEN }}
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
      - uses: minicli/action-contributors@v3.2.1
        name: "Update a projects CONTRIBUTORS file"
        env:
          CONTRIB_REPOSITORY: 'minicli/docs'
          CONTRIB_OUTPUT_FILE: 'CONTRIBUTORS.md'
      - name: Create a PR
        uses: peter-evans/create-pull-request@v3
        with:
          commit-message: Update Contributors
          title: "[automated] Update Contributors File"
          token: ${{ secrets.GITHUB_TOKEN }}
```

## Using a Custom Template

This action uses a simple templating lib that allows some customization for the final generated markdown file.

Here's how the default template looks like:

```markdown
# Top Contributors: {{ repo }}
Shout out to our top contributors!

{{ content }}

_Last updated: {{ updated }}_
```

The app will pass on the following variables to the template, which you can use as you prefer:
- `repo`: the repository from where the data is coming from. Ex: `minicli/minicli`
- `content`: the full list of contributors
- `updated`: date and time the file was generated in RFC822 format

To use a custom template, create a `.tpl` file based on the default template and include the `CONTRIB_TEMPLATE` env var to your workflow. This file must be committed to the same repository where the workflow is defined.

Here is an example of a workflow that uses a custom template called `mytemplate.tpl`, located at the root of the repository where the workflow is set:

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
      - uses: minicli/action-contributors@v3.2.1
        name: "Update a projects CONTRIBUTORS file"
        env:
          CONTRIB_REPOSITORY: 'minicli/minicli'
          CONTRIB_OUTPUT_FILE: 'CONTRIBUTORS.md'
          CONTRIB_TEMPLATE: ${{ github.workspace }}/mytemplate
      - name: Commit changes
        uses: test-room-7/action-update-file@v1
        with:
          file-path: 'CONTRIBUTORS.md'
          commit-msg: Update Contributors
          github-token: ${{ secrets.GITHUB_TOKEN }}
```

