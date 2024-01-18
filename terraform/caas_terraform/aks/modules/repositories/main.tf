resource "rafay_repositories" "public_repositories" {

  for_each = var.public_repositories
  metadata {
    name    = each.key
    project = var.project
  }
  
  spec {
    endpoint = each.value.endpoint
    type     = each.value.type
  }
}