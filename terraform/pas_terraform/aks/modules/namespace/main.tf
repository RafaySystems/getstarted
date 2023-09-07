resource "rafay_namespace" "namespace" {
  for_each = toset(var.namespaces)
  metadata {
    name    = each.key
    project = var.project
  }
  spec {
    drift {
      enabled = false
    }
  }
}