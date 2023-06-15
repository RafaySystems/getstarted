variable "project" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "overrides_config" {
  type = map(object({
    override_addon_name   = string
    override_values       = string
  }))
}