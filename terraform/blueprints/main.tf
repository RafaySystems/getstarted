module "project" {
  source      =  "./modules/project"
  project     = var.project
}

module "blueprint" {
  source                 = "./modules/blueprints"
  project                = var.project
  blueprint_name         = var.blueprint_name
  blueprint_version      = var.blueprint_version
  base_blueprint         = var.base_blueprint
  base_blueprint_version = var.base_blueprint_version
  depends_on             = [module.project]
}