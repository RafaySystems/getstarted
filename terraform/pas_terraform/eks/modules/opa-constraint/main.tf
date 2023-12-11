resource "rafay_opa_constraint" "opa-constraint" {
  for_each = toset(var.constraint_templates)
  metadata {
    name    = each.key
    project = var.project
    labels = {
      "rafay.dev/opa" = "constraint"
    }
  }
  spec {
    artifact {
      type = "Yaml"
      artifact {
        paths {
          name = "file://../../../turnkey-opa/opaconstraints/artifacts/${each.key}/${trimsuffix(each.key, "-custom")}.yaml"
        }
      }      
    }
    template_name = each.key
    version = "v1"
    published = true
  }
}