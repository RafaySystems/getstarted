resource "rafay_opa_installation_profile" "opa-installation-profile" {
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
    excluded_namespaces {
      namespaces {
        name = "default"
      }
      namespaces {
        name = "kube-public"
      }
      namespaces {
        name = "kube-node-lease"
      }
      namespaces {
        name = "ingress-nginx"
      }
      namespaces {
        name = "karpenter"
      }
    }
  }
}