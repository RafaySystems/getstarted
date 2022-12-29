module "project" {
  source      =  "./modules/project"
  project     = var.project
}

module "cloud-credentials" {
  source                  = "./modules/cloud-credentials"
  cloud_credentials_name  = var.cloud_credentials_name
  project                 = var.project
  client_id               = var.client_id
  client_secret           = var.client_secret
  subscription_id         = var.subscription_id
  tenant_id               = var.tenant_id
  depends_on              = [ module.project]
}

module cluster {
  source                 = "./modules/aks"
  cluster_name           = var.cluster_name
  project                = var.project
  blueprint_name         = var.blueprint_name
  blueprint_version      = var.blueprint_version
  cloud_credentials_name = var.cloud_credentials_name
  cluster_resource_group = var.cluster_resource_group
  k8s_version            = var.k8s_version
  cluster_location       = var.cluster_location
  nodePools             = var.nodePools
  depends_on             = [ module.cloud-credentials]
}
