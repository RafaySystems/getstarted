resource "rafay_eks_cluster" "cluster" {
  cluster {
    kind = "Cluster"
    metadata {
      name    = var.cluster_name
      project = var.project
      labels = {
        cluster = "test-label"
      }
    }
    spec {
      type           = "eks"
      blueprint      = var.blueprint_name
      blueprint_version = var.blueprint_version
      cloud_provider = var.cloud_credentials_name
      cni_provider   = "aws-cni"
      proxy_config   = {}
      system_components_placement {      
        tolerations {
          key       = var.rafay_tol_key
          operator  = var.rafay_tol_operator
          effect    = var.rafay_tol_effect
        }
        tolerations {
            key       = var.ds_tol_key
            operator  = var.ds_tol_operator
            effect    = var.ds_tol_effect
          }
        daemonset_override {
          node_selection_enabled = false
          tolerations {
            key       = var.ds_tol_key
            operator  = var.ds_tol_operator
            effect    = var.ds_tol_effect
          }
        }
      }
      }
    }
  cluster_config {
    apiversion = "rafay.io/v1alpha5"
    kind       = "ClusterConfig"
    metadata {
      name    = var.cluster_name
      region  = var.cluster_location
      version = var.k8s_version
      tags = var.cluster_tags
    }
    vpc {
      cidr = "192.168.0.0/16"
      cluster_endpoints {
        private_access = true
        public_access  = false
      }
      nat {
        gateway = "Single"
      }
    }
    dynamic "managed_nodegroups" {
	    for_each = var.managed_nodegroups
	    content {
	      name       = managed_nodegroups.value.ng_name
        ami_family = "AmazonLinux2"
        iam {
          iam_node_group_with_addon_policies {
            image_builder = true
            cloud_watch   = true
            }
        }
        instance_type    = managed_nodegroups.value.instance_type
        desired_capacity = managed_nodegroups.value.node_count
        min_size         = managed_nodegroups.value.node_min_count
        max_size         = managed_nodegroups.value.node_max_count
        version          = managed_nodegroups.value.k8s_version
        volume_size      = 80
        volume_type      = "gp3"
        volume_iops      = 3000
        volume_throughput = 125
        private_networking = true
        taints {
          key       = var.ds_tol_key
          effect    = var.ds_tol_effect
        }
        taints {
          key       = managed_nodegroups.value.taint_key
          effect    = managed_nodegroups.value.taint_effect
        }
	    }
    }
  }
}
