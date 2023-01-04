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

module eks_cluster {
  source                 = "./modules/eks"
  cluster_name           = var.cluster_name
  project                = var.project
  blueprint_name         = var.blueprint_name
  blueprint_version      = var.blueprint_version
  cloud_credentials_name = var.cloud_credentials_name
  k8s_version            = var.k8s_version
  cluster_location       = var.cluster_location
  managed_nodegroups     = var.managed_nodegroups
  depends_on             = [ module.cloud-credentials]
}