variable "owner" {
  description = "GitHub owner"
  type        = string
}

variable "repos" {
  description = "List of repos"
  type = map(map({
    allow_auto_merge       = bool
    allow_rebase_merge     = bool
    allow_merge_commit     = bool
    allow_squash_merge     = bool
    archived               = bool
    default_branch         = string
    delete_branch_on_merge = bool
    description            = string
    has_issues             = bool
    has_projects           = bool
    has_wiki               = bool
    homepage_url           = string
    is_template            = bool
    visibility             = string
    topics                 = list(any)
    vulnerability_alerts   = bool
    enforce_admins         = bool
    require_pr             = bool
    required_checks        = list(any)
    required_reviews       = number
    require_linear         = bool
    require_signature      = bool
    dismiss_stale          = bool
    last_push_approval     = bool
  }))
}

variable "defaults" {
  description = "repo defaults"
  type = object({
    allow_auto_merge       = bool
    allow_rebase_merge     = bool
    allow_merge_commit     = bool
    allow_squash_merge     = bool
    archived               = bool
    default_branch         = string
    delete_branch_on_merge = bool
    description            = string
    has_issues             = bool
    has_projects           = bool
    has_wiki               = bool
    homepage_url           = string
    is_template            = bool
    visibility             = string
    topics                 = list(any)
    vulnerability_alerts   = bool
    enforce_admins         = bool
    require_pr             = bool
    required_checks        = list(any)
    required_reviews       = number
    require_linear         = bool
    require_signature      = bool
    dismiss_stale          = bool
    last_push_approval     = bool
  })
}

variable "secrets" {
  description = "repo secrets"
  type        = map(any)
}

variable "secret_rotation" {
  description = "repo secret rotation"
  type        = string
}
