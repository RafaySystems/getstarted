variable "rafay_config_file" {
  type    = string
  default = "../artifacts/credentials/config.json"
}

variable "project" {
  type = string
}

variable "cloud_credentials_name" {
  type = string
}

variable "client_id" {
  type = string
}

variable "client_secret" {
  type = string
}

variable "subscription_id" {
  type = string
}

variable "tenant_id" {
  type = string
}

variable "cluster_name" {
    type = string
}

variable "cluster_location" {
  type = string
}

variable "cluster_resource_group" {
  type = string
}

variable "k8s_version" {
  type = string
}

variable "nodePools" {
  type = map(object({
    name          = string
    location      = string
    count         = number
    maxCount      = string
    minCount      = string
    mode          = string
    k8sVersion    = string
    vmSize        = string
  }))
}

variable "cluster_tags" {
  type = map
}

variable "node_tags" {
  type = map
}

variable "node_labels" {
  type = map
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

variable "namespaces" {
    type = list(string)
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
    depends_on    = list(string)
  }))
}

variable "public_repositories" {
  type = map(object({
    endpoint  = string
    type      = string
  }))
}

variable "overrides_config" {
  type = map(object({
    override_addon_name   = string
    override_values       = string
  }))
}

