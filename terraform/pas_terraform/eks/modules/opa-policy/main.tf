resource "rafay_project" "project" {
  metadata {
    name           = "default-opa-policy"
    project        = var.project
  }
  spec {
    constraint_list {
      name = "tfdemoopaconstraint1"
      version = "v1"
    }
    sharing {
      enabled = false
    }
    version = "v0"
  }
}