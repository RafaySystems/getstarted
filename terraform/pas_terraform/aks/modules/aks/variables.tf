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

variable "cluster_resource_group" {
  type = string
}

variable "cluster_location" {
  type = string
}

variable "k8s_version" {
  type = string
}

variable "cluster_tags" {
  type = map
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