data "github_repositories" "archived" {
  query           = "owner:${var.owner} archived:true"
  include_repo_id = true
}

resource "github_repository" "repository" {
  for_each = var.repositories

  name                   = each.key
  has_downloads          = false
  allow_auto_merge       = try(coalesce(each.value.allow_auto_merge), var.defaults.allow_auto_merge)
  allow_merge_commit     = try(coalesce(each.value.allow_merge_commit), var.defaults.allow_merge_commit)
  allow_rebase_merge     = try(coalesce(each.value.allow_rebase_merge), var.defaults.allow_rebase_merge)
  allow_squash_merge     = try(coalesce(each.value.allow_squash_merge), var.defaults.allow_squash_merge)
  archived               = try(coalesce(each.value.archived), var.defaults.archived)
  delete_branch_on_merge = try(coalesce(each.value.delete_branch_on_merge), var.defaults.delete_branch_on_merge)
  description            = try(coalesce(each.value.description), var.defaults.description)
  has_issues             = try(coalesce(each.value.has_issues), var.defaults.has_issues)
  has_projects           = try(coalesce(each.value.has_projects), var.defaults.has_projects)
  has_wiki               = try(coalesce(each.value.has_wiki), var.defaults.has_wiki)
  homepage_url           = try(coalesce(each.value.homepage_url), var.defaults.homepage_url)
  is_template            = try(coalesce(each.value.is_template), var.defaults.is_template)
  visibility             = try(coalesce(each.value.visibility), var.defaults.visibility)
  topics                 = try(coalesce(each.value.topics), var.defaults.topics)
  vulnerability_alerts   = try(coalesce(each.value.vulnerability_alerts), var.defaults.vulnerability_alerts)

  dynamic "pages" {
    for_each = try([coalesce(each.value.pages)], [])

    content {
      cname = try(pages.value.cname, null)

      source {
        branch = try(coalesce(pages.value.branch), "docs")
        path   = try(coalesce(pages.value.path), "/")
      }
    }
  }

  dynamic "template" {
    for_each = try([coalesce(each.value.template_repo)], [])

    content {
      owner      = element(split("/", template.value), 0)
      repository = element(split("/", template.value), 1)
    }
  }

  # needed for branch protection
  auto_init = true

  lifecycle {
    prevent_destroy = true
  }
}

resource "github_branch_default" "default" {
  for_each = {
    for repo, config in var.repositories : repo => try(coalesce(config.default_branch), var.defaults.default_branch)
    if contains(data.github_repositories.archived.names, repo) == false # exclude archived repos
  }

  repository = each.key
  branch     = each.value

  depends_on = [
    github_repository.repository
  ]
}

resource "github_actions_repository_access_level" "actions_access_level" {
  for_each = {
    for repo, config in var.repositories : repo => try(coalesce(config.actions_access_level), var.defaults.actions_access_level)
    if
    contains(data.github_repositories.archived.names, repo) == false # exclude archived repos
    &&
    github_repository.repository[repo].visibility != "public" # exclude public repos
  }

  access_level = each.value
  repository   = each.key

  depends_on = [
    github_repository.repository
  ]
}

resource "github_branch_protection" "branch_protection" {
  for_each = {
    for x in flatten([
      for repo, config in var.repositories : [
        for branch in try([coalesce(config.protected_branches)], [var.defaults.default_branch]) : {
          repo               = repo
          branch             = branch
          enforce_admins     = try(coalesce(config.enforce_admins), var.defaults.enforce_admins)
          require_pr         = try(coalesce(config.require_pr), var.defaults.require_pr)
          required_checks    = try(coalesce(config.required_checks), var.defaults.required_checks)
          require_linear     = try(coalesce(config.require_linear), var.defaults.require_linear)
          required_reviews   = try(coalesce(config.required_reviews), var.defaults.required_reviews)
          require_signature  = try(coalesce(config.require_signature), var.defaults.require_signature)
          dismiss_stale      = try(coalesce(config.dismiss_stale), var.defaults.dismiss_stale)
          last_push_approval = try(coalesce(config.last_push_approval), var.defaults.last_push_approval)
        }
      ] if contains(data.github_repositories.archived.names, repo) == false # exclude archived repos
    ]) : "${x.repo}:${x.branch}" => x
  }

  repository_id           = each.value.repo
  pattern                 = each.value.branch
  require_signed_commits  = each.value.require_signature
  required_linear_history = each.value.require_linear
  enforce_admins          = each.value.enforce_admins

  dynamic "required_status_checks" {
    for_each = length(each.value.required_checks) > 0 ? [each.value.required_checks] : []

    content {
      strict   = true
      contexts = required_status_checks.value
    }
  }

  dynamic "required_pull_request_reviews" {
    for_each = each.value.require_pr ? [0] : []

    content {
      dismiss_stale_reviews           = each.value.dismiss_stale
      require_last_push_approval      = each.value.last_push_approval
      required_approving_review_count = each.value.required_reviews
    }
  }

  depends_on = [
    github_repository.repository
  ]
}

resource "github_actions_secret" "shared" {
  for_each = {
    for x in flatten([
      for repo, config in var.repositories : [
        for name in try(coalesce(config.secrets), []) : {
          repo = repo
          name = name
        }
      ] if can(config.secrets) # exclude repos without secrets
    ]) : "${x.repo}:${x.name}:${var.secret_rotation}" => x
  }

  repository      = each.value.repo
  secret_name     = each.value.name
  plaintext_value = lookup(var.secrets, each.value.name)

  depends_on = [
    github_repository.repository
  ]
}
