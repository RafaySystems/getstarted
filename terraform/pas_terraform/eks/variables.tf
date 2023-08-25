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

variable "rolearn" {
  type = string
  default = "null"
}

variable "externalid" {
  type = string
  default = "null"
}

variable "cluster_name" {
    type = string
}

variable "cluster_location" {
  type = string
}

variable "k8s_version" {
  type = string
}

variable "ds_tol_key" {
  type = string
}

variable "ds_tol_operator" {
  type = string
}

variable "ds_tol_effect" {
  type = string
}

variable "managed_nodegroups" {
  type = map(object({
    ng_name        = string
	  node_count     = string
	  node_max_count = string
	  node_min_count = string
	  instance_type  = string
	  k8s_version    = string
    taint_key      = string
    taint_operator = string
    taint_effect   = string
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

