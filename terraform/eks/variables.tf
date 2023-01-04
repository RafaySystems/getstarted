variable "project" {
  type = string
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

variable "cluster_name" {
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

variable "rolearn" {
  type = string
}

variable "externalid" {
  type = string
}

variable "managed_nodegroups" {
  type = map(object({
    ng_name = string
	node_count = string
	node_max_count = string
	node_min_count = string
	instance_type = string
	k8s_version    = string
  }))
}