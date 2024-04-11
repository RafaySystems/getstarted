resource "rafay_opa_policy" "opa-policy" {
  count = var.opa-repo != "" ? 1 : 0
  metadata {
    name           = "default-opa-policy"
    project        = var.project
  }
  spec {
    dynamic "constraint_list" {
      for_each = var.constraint_templates
      content {
        name = constraint_list.value
        version = "v1"
      }
    }
    sharing {
      enabled = false
    }
    version = "v1"
  }
}
