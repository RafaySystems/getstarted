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

module "namespace" {
  source      = "./modules/namespace"
  project     = var.project
  namespaces  = var.namespaces
  depends_on           = [ module.project]
}

module "opa-constraint-template" {
  source                = "./modules/opa-constraint-template"
  project               = var.project
  opa-repo              = var.opa-repo
  opa-branch            = var.opa-branch  
  constraint_templates  = var.constraint_templates
  depends_on            = [ module.project, module.repositories ]
}

module "opa-constraint" {
  source                = "./modules/opa-constraint"
  project               = var.project
  opa-repo              = var.opa-repo
  opa-branch            = var.opa-branch  
  constraint_templates  = var.constraint_templates
  depends_on            = [ module.opa-constraint-template, module.repositories ]
}

module "opa_installation_profile" {
  source      =  "./modules/opa-installation-profile"
  project     = var.project
  opa_excluded_namespaces = var.opa_excluded_namespaces
  depends_on  = [ module.project, module.repositories ]
}

module "opa-policy" {
  source               = "./modules/opa-policy"
  project              = var.project
  constraint_templates = var.constraint_templates
  depends_on           = [ module.addons, module.repositories, module.opa_installation_profile, module.opa-constraint, module.opa-constraint-template ]
}

module "addons" {
 source               = "./modules/addons"
 project              = var.project
 infra_addons         = var.infra_addons
 depends_on           = [ module.repositories, module.namespace ]
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
 depends_on             = [ module.addons, module.opa-policy, module.opa_installation_profile, module.repositories ]
}

module aks_cluster {
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
  nodePools              = var.nodePools
  depends_on             = [ module.cloud-credentials, module.blueprint, module.cluster-overrides]
}
