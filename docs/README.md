## Usage

```tf
module "github" {
  source = "github.com/ahmadnassri/terraform-module-github"

  repos = { ... }
}
```

## Inputs

| Name       | Type     | Default | Required | Description                      |
| ---------- | -------- | ------- | -------- | -------------------------------- |
| `owner`    | `string` | `-`     | ✅       | github owner                     |
| `repos`    | `map`    | `-`     | ✅       | repositories configuration       |
| `defaults` | `object` | `{}`    | ❌       | default repository configuration |
| `secrets`  | `object` | `{}`    | ❌       | secrets to manage                |

## `repos`

A `map` of repositories to create / manage

```tf
repos = {
  <name> = { <configuration> },
  <name> = { <configuration> },
  ...
}
```

###### Example

```tf
repos = {
  terraform = {
    description = "infrastructure as code"
  }
}
```

| Name                     | Type           | Default  | Required | Description                                                      |
| ------------------------ | -------------- | -------- | -------- | ---------------------------------------------------------------- |
| **`name`**               | `string`       | `-`      | ✅       | the GitHub repository name                                       |
| `allow_merge_commit`     | `bool`         | `false`  | ❌       | allow merging pull requests with a merge commit,                 |
| `allow_rebase_merge`     | `bool`         | `true`   | ❌       | allow rebase-merging pull requests                               |
| `allow_squash_merge`     | `bool`         | `true`   | ❌       | allow squash-merging pull requests                               |
| `archived`               | `bool`         | `false`  | ❌       | archive this repository?                                         |
| `default_branch`         | `string`       | `master` | ❌       | updates the default branch for this repository.                  |
| `delete_branch_on_merge` | `bool`         | `true`   | ❌       | automatically delete head branches when pull requests are merged |
| `description`            | `string`       | `-`      | ❌       | a short description of the repository                            |
| `has_issues`             | `bool`         | `false`  | ❌       | enable issues for this repository                                |
| `has_projects`           | `bool`         | `false`  | ❌       | enable projects for this repository                              |
| `has_wiki`               | `bool`         | `false`  | ❌       | enable the wiki for this repository                              |
| `homepage_url`           | `string`       | `-`      | ❌       | a URL with more information about the repository                 |
| `is_template`            | `bool`         | `false`  | ❌       | make this repository available as a template repository          |
| `private`                | `bool`         | `true`   | ❌       | create a private repository                                      |
| `topics`                 | `list(string)` | `[]`     | ❌       | an array of topics to add to the repository.                     |
