resource "rafay_eks_cluster" "cluster" {
  name         = var.cluster_name
  projectname  = var.project_name
  yamlfilepath = var.cluster_spec_path
  yamlfileversion = var.cluster_spec_version
}
