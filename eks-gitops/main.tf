module "rafay_cluster" {
  source = "./modules/rafay_cluster"
  for_each = var.clusters
  cluster_name = each.value["cluster_name"]
  project_name      = each.value["project_name"]
  cluster_spec_version      = each.value["cluster_spec_version"]
  cluster_spec_path      = each.value["cluster_spec_path"]
}

