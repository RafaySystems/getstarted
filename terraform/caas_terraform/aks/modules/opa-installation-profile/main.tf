resource "rafay_opa_installation_profile" "opa-installation-profile" {
  count = var.opa-repo != "" ? 1 : 0
  metadata {
    name    = "default-opa-profile"
    project = var.project
  }
  spec {
    version = "v1"
    installation_params {
      audit_interval              = 60
      audit_match_kind_only       = true
      constraint_violations_limit = 20
      audit_chunk_size            = 20
      log_denies                  = true
      emit_audit_events           = true
    }
    dynamic "excluded_namespaces" {
      for_each = toset(var.opa_excluded_namespaces)
      content {
        namespaces {
          name = excluded_namespaces.value
        }
      }
    }
  }
}
