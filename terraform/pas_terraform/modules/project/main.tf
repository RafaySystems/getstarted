resource "rafay_project" "project" {
  metadata {
    name        = var.project
  }
  spec {
    default = false
  }
}