variable "owner" {
  description = "GitHub owner"
  type        = string
}

variable "repos" {
  description = "List of repos"
  type = map(object({
    allow_auto_merge       = optional(bool)
    allow_rebase_merge     = optional(bool)
    allow_merge_commit     = optional(bool)
    allow_squash_merge     = optional(bool)
    archived               = optional(bool)
    default_branch         = optional(string)
    delete_branch_on_merge = optional(bool)
    description            = optional(string)
    has_issues             = optional(bool)
    has_projects           = optional(bool)
    has_wiki               = optional(bool)
    homepage_url           = optional(string)
    is_template            = optional(bool)
    visibility             = optional(string)
    topics                 = optional(list(any))
    vulnerability_alerts   = optional(bool)
    enforce_admins         = optional(bool)
    require_pr             = optional(bool)
    required_checks        = optional(list(any))
    required_reviews       = optional(number)
    require_linear         = optional(bool)
    require_signature      = optional(bool)
    dismiss_stale          = optional(bool)
    last_push_approval     = optional(bool)
  }))
}

variable "defaults" {
  description = "repo defaults"
  type = object({
    allow_auto_merge       = optional(bool)
    allow_rebase_merge     = optional(bool)
    allow_merge_commit     = optional(bool)
    allow_squash_merge     = optional(bool)
    archived               = optional(bool)
    default_branch         = optional(string)
    delete_branch_on_merge = optional(bool)
    description            = optional(string)
    has_issues             = optional(bool)
    has_projects           = optional(bool)
    has_wiki               = optional(bool)
    homepage_url           = optional(string)
    is_template            = optional(bool)
    visibility             = optional(string)
    topics                 = optional(list(any))
    vulnerability_alerts   = optional(bool)
    enforce_admins         = optional(bool)
    require_pr             = optional(bool)
    required_checks        = optional(list(any))
    required_reviews       = optional(number)
    require_linear         = optional(bool)
    require_signature      = optional(bool)
    dismiss_stale          = optional(bool)
    last_push_approval     = optional(bool)
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
