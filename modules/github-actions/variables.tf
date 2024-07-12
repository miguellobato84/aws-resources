variable "repository" {
  type        = string
  description = "Github repository name"
}

variable "plan" {
  type = object({
    enabled             = bool
    role_name           = optional(string)
    additional_policies = optional(list(any), [])
  })
  default = {
    enabled = false
  }
}

variable "apply" {
  type = object({
    enabled   = bool
    role_name = optional(string)
    branch    = optional(string, "")
  })
  default = {
    enabled = false
  }
  validation {
    condition     = var.apply.enabled == false || (var.apply.enabled == true && var.apply.branch != "")
    error_message = "apply.branch must be set when apply.enabled is true"
  }
}
