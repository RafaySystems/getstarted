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
