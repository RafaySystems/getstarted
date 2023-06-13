variable "project" {
  type = string
}

variable "public_repositories" {
  type = map(object({
    endpoint  = string
    type      = string
  }))
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

variable "rafay_config_file" {
  type    = string
  default = "./artifacts/credentials/config.json"
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

variable "cluster_name" {
    type = string
}

variable "namespaces" {
    type = list(string)
}

variable "cloud_credentials_name" {
  type = string
}

variable "cluster_resource_group" {
  type = string
}

variable "cluster_location" {
  type = string
}

variable "k8s_version" {
  type = string
}

variable "nodepool_name" {
  type = string
}

variable "node_count" {
  type = string
}

variable "node_max_count" {
  type = string
}

variable "node_min_count" {
  type = string
}

variable "vm_size" {
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

variable "cluster_tags" {
  type = map
}

variable "node_tags" {
  type = map
}

variable "node_labels" {
  type = map
}

variable "overrides_config" {
  type = map(object({
    override_addon_name   = string
    override_values       = string
  }))
}

variable "rolearn" {
  type = string
}

variable "externalid" {
  type = string
}

variable "ng_name" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "sharing" {
  type = bool
}

variable "application_projects" {
  type = map(object({
    name          = string
    description   = string
    size          = string
    groups        = map(object({
         name  = string
         roles = list(string)
        }))
  }))
}
