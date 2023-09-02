variable "owner" {
  description = "GitHub owner"
  type        = string
}

variable "defaults" {
  description = "repo defaults"
  type = object({
    allow_auto_merge       = optional(bool, true)
    allow_rebase_merge     = optional(bool, true)
    allow_merge_commit     = optional(bool, false)
    allow_squash_merge     = optional(bool, false)
    archived               = optional(bool, false)
    default_branch         = optional(string, "master")
    delete_branch_on_merge = optional(bool, true)
    description            = optional(string, "")
    has_issues             = optional(bool, false)
    has_projects           = optional(bool, false)
    has_wiki               = optional(bool, false)
    homepage_url           = optional(string, "")
    is_template            = optional(bool, false)
    visibility             = optional(string, "private")
    topics                 = optional(list(string), [])
    vulnerability_alerts   = optional(bool, true)
    enforce_admins         = optional(bool, false)
    require_pr             = optional(bool, true)
    required_checks        = optional(list(string), [])
    required_reviews       = optional(number, 1)
    require_linear         = optional(bool, true)
    require_signature      = optional(bool, true)
    dismiss_stale          = optional(bool, true)
    last_push_approval     = optional(bool, false)
    template_repo          = optional(string, "")
    protected_branches     = optional(list(string), [])
    secrets                = optional(list(string))
    pages = optional(object({
      cname  = optional(string)
      branch = optional(string)
      path   = optional(string)
    }))
  })
}

variable "repositories" {
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
    topics                 = optional(list(string))
    vulnerability_alerts   = optional(bool)
    enforce_admins         = optional(bool)
    require_pr             = optional(bool)
    required_checks        = optional(list(string))
    required_reviews       = optional(number)
    require_linear         = optional(bool)
    require_signature      = optional(bool)
    dismiss_stale          = optional(bool)
    last_push_approval     = optional(bool)
    template_repo          = optional(string)
    protected_branches     = optional(list(string))
    secrets                = optional(list(string))
    pages = optional(object({
      cname  = optional(string)
      branch = optional(string)
      path   = optional(string)
    }))
  }))
}

variable "secrets" {
  description = "repo secrets"
  type        = map(any)
  default     = {}
}

variable "secret_rotation" {
  description = "repo secret rotation"
  type        = string
  default     = "now"
}
