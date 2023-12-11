variable "rafay_config_file" {
  type    = string
  default = "../artifacts/credentials/config.json"
  description = "The config file containing the credentials to authenticate"
}

variable "project" {
  type = string
  description = "The name of the project"
}

variable "cloud_credentials_name" {
  type = string
  description = "The name of the cloud credential"
}

variable "rolearn" {
  type = string
  default = "null"
  description = "The ARN of the IAM role used to provision clusters"
}

variable "externalid" {
  type = string
  default = "null"
  description = "The external id of the IAM role's trust relationship"
}

variable "instance_profile" {
  type = string
  default = "null"
  description = "The name of the IAM instance profile for Karpenter"
}

variable "cluster_name" {
    type = string
    description = "The name of the managed kubernetes cluster"
}

variable "cluster_location" {
  type = string
  description = "The AWS region the cluster will be provisioned"
}

variable "cluster_admin_iam_roles" {
  type        = list(string)
  description = "IAM Roles to be granted cluster-admin access"
}

variable "k8s_version" {
  type = string
  description = "The k8s version (ex: 1.26, 1.27)"
}

variable "cluster_labels" {
  type        = map(string)
  description = "Map of cluster labels for cluster"
}

variable "private_subnet_ids" {
  type        = map(string)
  description = "List of private subnet ids for EKS Control Plane and Node Groups"
}

variable "public_subnet_ids" {
  type        = map(string)
  description = "List of public subnet ids for EKS Control Plane and Node Groups"
}

variable "rafay_tol_key" {
  type = string
  description = "toleration key for placement of systems components"
}

variable "rafay_tol_operator" {
  type = string
  description = "toleration operator for placement of systems components"
}

variable "rafay_tol_effect" {
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
    taint_key      = optional(string)
    taint_operator = optional(string)
    taint_effect   = optional(string)
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

variable "constraint_templates" {
    type = list(string)
}

variable "infra_addons" {
  type = map(object({
    name          = string
    namespace     = string
    type          = string
    addon_version = string
    catalog       = optional(string)
    chart_name    = string
    chart_version = string
    repository    = optional(string)
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

