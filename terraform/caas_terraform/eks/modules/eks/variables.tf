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

variable "cluster_admin_iam_roles" {
  type        = list(string)
  description = "IAM Roles to be granted cluster-admin access."
}

variable "instance_profile" {
  type = string
  default = "null"
}

variable "k8s_version" {
  type = string
}

variable "s3_bucket" {
  type = string
  default = "null"
  description = "The name of the AWS S3 bucket for storing backups"
}

variable "cluster_labels" {
  type        = map(string)
  description = "Map of cluster labels for cluster"
}

variable "create_vpc" {
  type        = bool
  default     = true
  description = "Create VPC & Subnets"
}

variable "private_subnet_ids" {
  type        = map(string)
  default     = {}
  description = "List of subnet ids for EKS Control Plane and Node Groups"
}

variable "public_subnet_ids" {
  type        = map(string)
  default     = {}
  description = "List of subnet ids for EKS Control Plane and Node Groups"
}

variable "rafay_tol_key" {
  type = string
}

variable "rafay_tol_operator" {
  type = string
}

variable "rafay_tol_effect" {
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
    taint_key      = optional(string)
    taint_operator = optional(string)
    taint_effect   = optional(string)
    labels         = optional(map(string))
  }))
}

variable "cluster_tags" {
  type = map
}
