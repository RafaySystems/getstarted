variable "project" {
  type = string
}

variable "infra_addons" {
  type = map(object({
    name          = string
    namespace     = string
    type          = string
    addon_version = string
    catalog       = optional(string)
    chart_name    = string
    chart_version = string
    repository    = optional(string)
    file_path     = string
  }))
}
