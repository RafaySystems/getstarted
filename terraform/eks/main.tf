module "project" {
  source      =  "./modules/project"
  project     = var.project
}

module "cloud-credentials" {
  source                  = "./modules/cloud-credentials"
  cloud_credentials_name  = var.cloud_credentials_name
  project                 = var.project
  rolearn                 = var.rolearn
  externalid              = var.externalid
  depends_on              = [ module.project]
}

module cluster {
  source                 = "./modules/eks"
  cluster_name           = var.cluster_name
  cluster_tags           = var.cluster_tags
  project                = var.project
  blueprint_name         = var.blueprint_name
  blueprint_version      = var.blueprint_version
  cloud_credentials_name = var.cloud_credentials_name
  k8s_version            = var.k8s_version
  cluster_location       = var.cluster_location
  ng_name                = var.ng_name
  node_count             = var.node_count
  node_max_count         = var.node_max_count
  node_min_count         = var.node_min_count
  instance_type          = var.instance_type
  node_tags              = var.node_tags
  node_labels            = var.node_labels
  depends_on             = [ module.cloud-credentials]
}