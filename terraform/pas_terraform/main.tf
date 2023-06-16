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
  rolearn                 = var.rolearn
  externalid              = var.externalid
  depends_on              = [ module.project]
}
  
module "group" {
  source      = "./modules/group"
  group       = "${var.project}-project-admin"
}
  
module "group-association" {
  source      = "./modules/group-association"
  group       = "${var.project}-project-admin"
  project     = var.project
  depends_on  = [ module.group]
}
  
module "repositories" {
 source               = "./modules/repositories"
 project              = var.project
 public_repositories  = var.public_repositories
 depends_on           = [ module.project]
}
  
module "addons" {
 source               = "./modules/addons"
 project              = var.project
 infra_addons         = var.infra_addons
 depends_on           = [ module.repositories]
}
  
module "cluster-overrides" {
 source               = "./modules/cluster-overrides"
 project              = var.project
 cluster_name         = var.cluster_name
 overrides_config     = var.overrides_config
 depends_on           = [ module.addons]
}
  
module "blueprint" {
 source                 = "./modules/blueprints"
 project                = var.project
 blueprint_name         = var.blueprint_name
 blueprint_version      = var.blueprint_version
 base_blueprint         = var.base_blueprint
 base_blueprint_version = var.base_blueprint_version
 infra_addons           = var.infra_addons
 depends_on           = [ module.addons ]
}
  
module aks_cluster {
 count                  = var.subscription_id == "" ? 0 : 1
 source                 = "./modules/aks"
 cluster_name           = var.cluster_name
 cluster_tags           = var.cluster_tags
 project                = var.project
 blueprint_name         = var.blueprint_name
 blueprint_version      = var.blueprint_version
 cloud_credentials_name = var.cloud_credentials_name
 cluster_resource_group = var.cluster_resource_group
 k8s_version            = var.k8s_version
 cluster_location       = var.cluster_location
 nodepool_name          = var.nodepool_name
 node_count             = var.node_count
 node_max_count         = var.node_max_count
 node_min_count         = var.node_min_count
 vm_size                = var.vm_size
 node_tags              = var.node_tags
 node_labels            = var.node_labels
 depends_on             = [ module.cloud-credentials, module.blueprint, module.cluster-overrides]
}

module eks_cluster {
count                  = var.rolearn == "" ? 0 : 1
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
depends_on             = [ module.cloud-credentials, module.blueprint, module.cluster-overrides]
} 
