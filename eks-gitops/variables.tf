variable "clusters" {
  type = map(object({
    cluster_name        = string
    project_name = string
    cluster_spec_version  = string
    cluster_spec_path  = string
  }))
}
