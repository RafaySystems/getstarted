resource "rafay_cluster_override" "override" {

  for_each = var.overrides_config
  metadata {
    name    = each.key
    project = var.project
    labels = {
      "rafay.dev/overrideScope" = "clusterLabels"
      "rafay.dev/overrideType"  = "valuesFile"
    }
  }
  spec {
    cluster_selector  = "rafay.dev/clusterName in (${var.cluster_name})"
    cluster_placement {
      placement_type = "ClusterSpecific"
      cluster_labels {
        key = "rafay.dev/clusterName"
        value = var.cluster_name
      }
    }
    resource_selector = "rafay.dev/name=${each.value.override_addon_name}"
    type              = "ClusterOverrideTypeAddon"
    override_values   = each.value.override_values
  }
}