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
  description = "The ARN of the IAM role used to provision clusters"
}

variable "externalid" {
  type = string
  description = "The external id of the IAM role's trust relationship"
}

variable "instance_profile" {
  type = string
  default = null
  description = "The name of the IAM instance profile for Karpenter. This also deploys an IRSA!"
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
  default = []
  description = "IAM Roles to be granted cluster-admin access"
}

variable "k8s_version" {
  type = string
  description = "The k8s version (ex: 1.26, 1.27)"
}

variable "s3_bucket" {
  type = string
  default = null
  description = "The name of the AWS S3 bucket for storing backups. This also installs an IRSA!"
}

variable "cluster_labels" {
  type        = map(string)
  description = "Map of cluster labels for cluster"
}

variable "private_subnet_ids" {
  type        = map(string)
  default     = {}
  description = "List of private subnet ids for EKS Control Plane and Node Groups if customer provided"
}

variable "public_subnet_ids" {
  type        = map(string)
  default     = {}
  description = "List of public subnet ids for EKS Control Plane and Node Groups if customer provided"
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
  description = "toleration effect for placement of systems components"
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
  description = "configuration of EKS managed nodegroup"
}

variable "cluster_tags" {
  type = map
  default = {}
  description = "tags for managed k8s cluster"
}

variable "node_tags" {
  type = map
  default = {}
  description = "tags added to cloud infrastructure"
}

variable "blueprint_name" {
  type = string
  description = "name of the blueprint"
}

variable "blueprint_version" {
  type = string
  description = "version of the blueprint"
}

variable "base_blueprint" {
  type = string
  description = "base blueprint to build custom blueprint off of, ex: (default, minimal, etc..)"
}

variable "base_blueprint_version" {
  type = string
  description = "base blueprint version of managed components, ex: (2.1.0, 2.2.0, 2.3.0)"
}

variable "namespaces" {
    type = list(string)
    description = "namespaces to be added to the cluster"
}

variable "constraint_templates" {
    type = list(string)
    default = []
    description = "name of the constraints and constraint templates to deploy via a default opa policy"
}

variable "infra_addons" {
  type = map(object({
    name          = string
    namespace     = string
    type          = string
    addon_version = string
    catalog       = optional(string)
    chart_name    = optional(string)
    chart_version = optional(string)
    repository    = optional(string)
    file_path     = string
    depends_on    = list(string)
  }))
  default = {}
  description = "configuration of the addons to be added to the project"
}

variable "public_repositories" {
  type = map(object({
    endpoint  = string
    type      = string
  }))
  default     = {}
  description = "configuration of repositories to be added to the project"
}

variable "opa-repo" {
  type = string
  default = null
  description = "name of the repo housing opa constraint and constraint templates"
}

variable "opa-branch" {
  type = string
  default = null
  description = "name of the repo housing opa constraint and constraint templates"
}

variable "opa_excluded_namespaces" {
  type = list(string)
  default = []
  description = "namespaces to be excluded from OPA scanning"
}

variable "overrides_config" {
  type = map(object({
    override_addon_name   = string
    override_values       = string
  }))
  default     = {}
  description = "configuration of the overrides for the addons"
}

