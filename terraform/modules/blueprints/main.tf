resource "rafay_blueprint" "blueprint" {
  metadata {
    name    = var.blueprint_name
    project = var.project
  }
  spec {
    version = var.blueprint_version
    base {
      name    = var.base_blueprint
      version = var.base_blueprint_version
    }
    dynamic "custom_addons" {
      for_each = var.infra_addons
      content {
        name = custom_addons.key
        version = custom_addons.value.addon_version
      }
    }
    default_addons {
      enable_ingress    = false
      enable_monitoring = true
    }
    drift {
      action  = "Deny"
      enabled = true
    }
    sharing {
      enabled = false
    }
    namespace_config {
      enable_sync = true
    }
    network_policy {
      enabled = true
      profile {
        name = "default"
      }
    }
  }
}