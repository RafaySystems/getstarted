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