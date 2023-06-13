locals {
  apps = distinct(flatten([
    for entry in var.application_projects : [
      for group in entry.groups : {
        name        = entry.name
        size         = entry.size
        group        = group.name
        role         = group.roles
      }
    ]
  ]))
}

resource "rafay_project" "app_project" {
  for_each = var.application_projects
  metadata {
    name        = each.value.name
  }
  spec {
    default = false
    cluster_resource_quota {
      cpu_requests = var.project_quotas[each.value.size]["cpu_requests"]
      memory_requests = var.project_quotas[each.value.size]["memory_requests"]
      cpu_limits = var.project_quotas[each.value.size]["cpu_limits"]
      memory_limits = var.project_quotas[each.value.size]["memory_limits"]
      config_maps = var.project_quotas[each.value.size]["config_maps"]
      persistent_volume_claims = var.project_quotas[each.value.size]["memory_requests"]
      services = var.project_quotas[each.value.size]["services"]   
      pods = var.project_quotas[each.value.size]["pods"]
      replication_controllers = var.project_quotas[each.value.size]["replication_controllers"]
      services_load_balancers = var.project_quotas[each.value.size]["services_load_balancers"]
      services_node_ports = var.project_quotas[each.value.size]["services_node_ports"]
      storage_requests = var.project_quotas[each.value.size]["storage_requests"]
  }
  default_cluster_namespace_quota {
      cpu_requests = var.namespace_quotas[each.value.size]["cpu_requests"]
      memory_requests = var.namespace_quotas[each.value.size]["memory_requests"]
      cpu_limits = var.namespace_quotas[each.value.size]["cpu_limits"]
      memory_limits = var.namespace_quotas[each.value.size]["memory_limits"]
      config_maps = var.namespace_quotas[each.value.size]["config_maps"]
      persistent_volume_claims = var.namespace_quotas[each.value.size]["memory_requests"]
      services = var.namespace_quotas[each.value.size]["services"]   
      pods = var.namespace_quotas[each.value.size]["pods"]
      replication_controllers = var.namespace_quotas[each.value.size]["replication_controllers"]
      services_load_balancers = var.namespace_quotas[each.value.size]["services_load_balancers"]
      services_node_ports = var.namespace_quotas[each.value.size]["services_node_ports"]
      storage_requests = var.namespace_quotas[each.value.size]["storage_requests"]

  }
 }
}

resource "rafay_group" "group-dev" {
  for_each = {
    for group in local.apps : "${group.name}.${group.group}" => group
  }
  name    = each.value.group
}

resource "rafay_groupassociation" "group-dev-association" {
  for_each = {
    for group in local.apps : "${group.name}.${group.group}" => group
  }
  group      = each.value.group
  project    = each.value.name
  roles      = each.value.role
  depends_on = [ rafay_group.group-dev, rafay_project.app_project ]
}