resource "rafay_blueprint" "blueprint" {
  metadata {
    name    = var.blueprint_name
    project = var.project
  }
  spec {
    version = "v0"
    base {
      name    = var.base_blueprint
      version = var.base_blueprint_version
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
      projects {
        name = "defaultprooject"
      }
    }
    placement {
      auto_publish = false
    }
  }
}