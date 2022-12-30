resource "rafay_eks_cluster" "cluster" {
  cluster {
    kind = "Cluster"
    metadata {
      name    = var.cluster_name
      project = var.project
    }
    spec {
      type           = "eks"
      blueprint      = var.blueprint_name
      blueprint_version = var.blueprint_version
      cloud_provider = var.cloud_credentials_name
      cni_provider   = "aws-cni"
      proxy_config   = {}
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
    managed_nodegroups {
      name       = var.ng_name
      ami_family = "AmazonLinux2"
      iam {
        iam_node_group_with_addon_policies {
          image_builder = true
          cloud_watch = true
          }
     }
      instance_type    = var.instance_type
      desired_capacity = var.node_count
      min_size         = var.node_min_count
      max_size         = var.node_max_count
      version          = var.k8s_version
      volume_size      = 80
      volume_type      = "gp3"
      volume_iops      = 3000
      volume_throughput = 125
      private_networking = true
      labels = var.node_labels
      tags = var.node_tags
    }
  }
}