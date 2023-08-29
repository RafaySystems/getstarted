resource "rafay_addon" "infra_addons" {
  for_each = {
    for k, v in var.infra_addons : k => v if v.file_path == null
  }
  metadata {
    name    = each.value.name
    project = var.project
  }
  spec {
    namespace = each.value.namespace
    version   =  each.value.addon_version
    artifact {
      type = "Helm"
      artifact {
        chart_name = each.value.chart_name
        chart_version = each.value.chart_version
        repository = each.value.repository
      }
    }
    sharing {
      enabled = false
    }
  }
}   

resource "rafay_addon" "infra_addons_with_custom_values" {
  for_each = {
    for k, v in var.infra_addons : k => v if v.file_path != null
  }
  metadata {
    name    = each.value.name
    project = var.project
  }
  spec {
    namespace = each.value.namespace
    version   =  each.value.addon_version
    artifact {
      type = "Helm"
      artifact {
        chart_name = each.value.chart_name
        chart_version = each.value.chart_version
        repository = each.value.repository
        values_paths {
          name = each.value.file_path != null ? each.value.file_path : ""
        }
      }
    }
    sharing {
      enabled = false
    }
  }
}   