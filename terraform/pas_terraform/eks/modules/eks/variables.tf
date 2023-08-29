variable "project" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "blueprint_name" {
  type = string
}

variable "blueprint_version" {
  type = string
}

variable "cloud_credentials_name" {
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
