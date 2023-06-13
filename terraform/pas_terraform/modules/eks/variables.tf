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

variable "ng_name" {
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

variable "instance_type" {
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