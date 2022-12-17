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

variable "infra_addons" {
  type = map(object({
    namespace     = string
    addon_version = string
    chart_name    = string
    chart_version = string
    repository    = string
    file_path     = string
  }))
}