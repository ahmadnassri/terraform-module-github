## Usage

```tf
module "github" {
  source = "github.com/ahmadnassri/terraform-module-github"

  repos = { ... }
}
```

## Inputs

| Name              | Type          | Default | Required | Description                      |
| ----------------- | ------------- | ------- | -------- | -------------------------------- |
| `owner`           | `string`      | `-`     | ✅       | github owner                     |
| `repositories`    | `map(object)` | `-`     | ✅       | repositories configuration       |
| `defaults`        | `object`      | `{}`    | ❌       | default repository configuration |
| `secrets`         | `map(any)`    | `{}`    | ❌       | secrets to manage                |
| `secret_rotation` | `string`      | `now`   | ❌       | secret rotation key              |

## `repositories`

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
  repository_name = {
    description = "a unique description for this repo"
    topics      = ["nodejs", "terraform", "github"]
  }
}
```

### `repositories` and `defaults`

| Name                     | Type           | Default   | Required | Description                                                      |
| ------------------------ | -------------- | --------- | -------- | ---------------------------------------------------------------- |
| `allow_auto_merge`       | `bool`         | `true`    | ❌       | allow auto-merging pull requests                                 |
| `allow_rebase_merge`     | `bool`         | `true`    | ❌       | allow rebase-merging pull requests                               |
| `allow_merge_commit`     | `bool`         | `false`   | ❌       | allow merging pull requests with a merge commit                  |
| `allow_squash_merge`     | `bool`         | `false`   | ❌       | allow squash-merging pull requests                               |
| `archived`               | `bool`         | `false`   | ❌       | archive this repository?                                         |
| `default_branch`         | `string`       | `master`  | ❌       | set the default branch for this repository.                      |
| `delete_branch_on_merge` | `bool`         | `true`    | ❌       | automatically delete head branches when pull requests are merged |
| `description`            | `string`       | `-`       | ❌       | a short description of the repository                            |
| `has_issues`             | `bool`         | `false`   | ❌       | enable issues for this repository                                |
| `has_projects`           | `bool`         | `false`   | ❌       | enable projects for this repository                              |
| `has_wiki`               | `bool`         | `false`   | ❌       | enable the wiki for this repository                              |
| `homepage_url`           | `string`       | `-`       | ❌       | a URL with more information about the repository                 |
| `is_template`            | `bool`         | `false`   | ❌       | make this repository available as a template repository          |
| `visibility`             | `string`       | `private` | ❌       | either `public` or `private`                                     |
| `topics`                 | `list(string)` | `[]`      | ❌       | a list of topics to add to the repository                        |
| `vulnerability_alerts`   | `bool`         | `true`    | ❌       | enable security alerts for this repository                       |
| `enforce_admins`         | `bool`         | `false`   | ❌       | block force pushes that alter the protected branch(es)           |
| `require_pr`             | `bool`         | `true`    | ❌       | require pull request reviews before merging                      |
| `required_checks`        | `list(string)` | `[]`      | ❌       | require status checks to pass before merging                     |
| `required_reviews`       | `number`       | `1`       | ❌       | require review from Code Owners before merging                   |
| `require_linear`         | `bool`         | `true`    | ❌       | require linear history                                           |
| `require_signature`      | `bool`         | `true`    | ❌       | require signed commits                                           |
| `dismiss_stale`          | `bool`         | `true`    | ❌       | dismiss approving reviews when someone pushes a new commit       |
| `last_push_approval`     | `bool`         | `false`   | ❌       | require review from Code Owners for the last push                |
| `template_repo`          | `string`       | `-`       | ❌       | the repository to use as a template for this repository          |
| `protected_branches`     | `list(string)` | `[]`      | ❌       | a list of branches to protect                                    |
| `secrets`                | `list(string)` | `string`  | ❌       | a list of secrets to manage                                      |
| `pages`                  | `object`       | `{}`      | ❌       | a map of pages configuration                                     |

#### `pages`

| Name     | Type     | Default | Required | Description                                    |
| -------- | -------- | ------- | -------- | ---------------------------------------------- |
| `path`   | `string` | `/`     | ❌       | the path to the directory containing the pages |
| `branch` | `string` | `docs`  | ❌       | the branch to use for publishing               |
| `cname`  | `string` | `-`     | ❌       | the custom domain to use for publishing        |
