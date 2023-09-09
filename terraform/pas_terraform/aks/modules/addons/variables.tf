variable "project" {
  type = string
}

variable "infra_addons" {
  type = map(object({
    name          = string
    namespace     = string
    addon_version = string
    chart_name    = string
    chart_version = string
    repository    = string
    file_path     = string
  }))
}
