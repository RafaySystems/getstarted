resource "rafay_opa_constraint_template" "opa-constraint-template" {
  for_each = toset(var.constraint_templates)
  metadata {
    name    = each.key
    project = var.project
  }
  spec {
    artifact {
      artifact {
        paths {
          name = "../../../../../turnkey-opa/opaconstrainttemplates/artifacts/${each.key}/${trim(each.key, "-custom")}.yaml"
        }
      }
      options {
        force = true
      }
      type = "Yaml"
    }
  }
}