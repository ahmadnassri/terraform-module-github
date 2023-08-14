locals {
  defaults = {
    repo = merge({
      allow_auto_merge       = true
      allow_rebase_merge     = true
      allow_merge_commit     = false
      allow_squash_merge     = false
      archived               = false
      default_branch         = "master"
      delete_branch_on_merge = true
      description            = ""
      has_issues             = false
      has_projects           = false
      has_wiki               = false
      homepage_url           = ""
      is_template            = false
      visibility             = "private"
      topics                 = []
      vulnerability_alerts   = true
      enforce_admins         = false
      require_pr             = true
      required_checks        = []
      required_reviews       = 1
      require_linear         = true
      require_signature      = true
      dismiss_stale          = true
      last_push_approval     = false
    }, try(var.defaults.repo, {}))
  }
}

# configure repository
resource "github_repository" "repository" {
  for_each = var.repos

  name                   = each.key
  has_downloads          = false
  allow_auto_merge       = try(each.value.allow_auto_merge, local.defaults.repo.allow_auto_merge)
  allow_merge_commit     = try(each.value.allow_merge_commit, local.defaults.repo.allow_merge_commit)
  allow_rebase_merge     = try(each.value.allow_rebase_merge, local.defaults.repo.allow_rebase_merge)
  allow_squash_merge     = try(each.value.allow_squash_merge, local.defaults.repo.allow_squash_merge)
  archived               = try(each.value.archived, local.defaults.repo.archived)
  delete_branch_on_merge = try(each.value.delete_branch_on_merge, local.defaults.repo.delete_branch_on_merge)
  description            = try(each.value.description, local.defaults.repo.description)
  has_issues             = try(each.value.has_issues, local.defaults.repo.has_issues)
  has_projects           = try(each.value.has_projects, local.defaults.repo.has_projects)
  has_wiki               = try(each.value.has_wiki, local.defaults.repo.has_wiki)
  homepage_url           = try(each.value.homepage_url, local.defaults.repo.homepage_url)
  is_template            = try(each.value.is_template, local.defaults.repo.is_template)
  visibility             = try(each.value.visibility, local.defaults.repo.visibility)
  topics                 = try(each.value.topics, local.defaults.repo.topics)
  vulnerability_alerts   = try(each.value.vulnerability_alerts, local.defaults.repo.vulnerability_alerts)

  dynamic "pages" {
    for_each = try([each.value.pages], [])

    content {
      cname = try(pages.value.cname, null)

      source {
        branch = try(pages.value.branch, "docs")
        path   = try(pages.value.path, "/")
      }
    }
  }

  dynamic "template" {
    for_each = try([each.value.template_repo], [])

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
    for repo, config in var.repos : repo => try(config.default_branch, local.defaults.repo.default_branch)
    if lookup(config, "archived", false) == false
  }

  repository = each.key
  branch     = each.value

  depends_on = [
    github_repository.repository
  ]
}

resource "github_branch_protection" "branch_protection" {
  for_each = {
    for x in flatten([
      for repo, config in var.repos : [
        for branch in try(config.protected_branches, [local.defaults.repo.default_branch]) : {
          repo               = repo
          branch             = branch
          enforce_admins     = try(config.enforce_admins, local.defaults.repo.enforce_admins)
          require_pr         = try(config.require_pr, local.defaults.repo.require_pr)
          required_checks    = try(config.required_checks, local.defaults.repo.required_checks)
          require_linear     = try(config.require_linear, local.defaults.repo.require_linear)
          required_reviews   = try(config.required_reviews, local.defaults.repo.required_reviews)
          require_signature  = try(config.require_signature, local.defaults.repo.require_signature)
          dismiss_stale      = try(config.dismiss_stale, local.defaults.repo.dismiss_stale)
          last_push_approval = try(config.last_push_approval, local.defaults.repo.last_push_approval)
        }
      ] if lookup(config, "archived", false) == false
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
      for repo, config in var.repos : [
        for name in config.secrets : {
          repo = repo
          name = name
        }
      ] if can(config.secrets)
    ]) : "${x.repo}:${x.name}:${var.secrets.ROTATION}" => x
  }

  repository      = each.value.repo
  secret_name     = each.value.name
  plaintext_value = lookup(var.secrets, each.value.name)

  depends_on = [
    github_repository.repository
  ]
}
