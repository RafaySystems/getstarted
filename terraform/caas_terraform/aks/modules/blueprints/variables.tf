variable "project" {
  type = string
}

variable "blueprint_name" {
  type = string
}

variable "blueprint_version" {
  type = string
}

variable "base_blueprint" {
  type = string
}

variable "base_blueprint_version" {
  type = string
}

variable "opa-repo" {
  type = string
}

variable "infra_addons" {
  type = map(object({
    name          = string
    namespace     = string
    addon_version = string
    catalog       = optional(string)
    chart_name    = string
    chart_version = string
    repository    = optional(string)
    file_path     = string
    depends_on    = list(string)
  }))
}
