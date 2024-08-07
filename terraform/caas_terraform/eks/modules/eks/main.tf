resource "rafay_eks_cluster" "cluster" {

  cluster {
    kind = "Cluster"
    metadata {
      name    = var.cluster_name
      project = var.project
      labels = var.cluster_labels
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
    identity_mappings {
      dynamic "arns" {
        for_each = toset(var.cluster_admin_iam_roles)
        content {
          arn      = arns.value
          group    = ["system:masters"] #k8s group
          username = "cluster-admin"
        }
      }
      dynamic "arns" {
        for_each = var.instance_profile != null ? [0] : []
        content {
          arn   = var.instance_profile
          group = ["system:bootstrappers", "system:nodes"]
          username = "system:node:{{EC2PrivateDNSName}}"
        }
      }
    }
    iam {
      with_oidc = "true"
      dynamic "service_accounts" {
        for_each = var.instance_profile != null ? [0] : []
        content {
          metadata {
            name      = "karpenter"
            namespace = "karpenter"
          }
          attach_policy = <<EOF
          {
            "Version": "2012-10-17",
            "Statement": [
              {
                  "Effect": "Allow",
                  "Action": [
                    "ec2:CreateLaunchTemplate",
                    "ec2:CreateFleet",
                    "ec2:RunInstances",
                    "ec2:CreateTags",
                    "iam:PassRole",
                    "iam:CreateInstanceProfile",
                    "iam:GetInstanceProfile",
                    "iam:TagInstanceProfile",
                    "iam:AddRoleToInstanceProfile",
                    "iam:RemoveRoleFromInstanceProfile",
                    "iam:DeleteInstanceProfile",
                    "ec2:TerminateInstances",
                    "ec2:DescribeLaunchTemplates",
                    "ec2:DescribeInstances",
                    "ec2:DescribeSecurityGroups",
                    "ec2:DescribeSubnets",
                    "ec2:DescribeImage",
                    "ec2:DescribeImages",
                    "ec2:DescribeInstanceTypes",
                    "ec2:DescribeInstanceTypeOfferings",
                    "ec2:DescribeAvailabilityZones",
                    "ec2:DeleteLaunchTemplate",
                    "ssm:GetParameter",
                    "eks:DescribeCluster",
                    "pricing:GetProducts",
                    "pricing:DescribeServices",
                    "pricing:GetAttributeValues",
                    "ec2:DescribeSpotPriceHistory"
                  ],
                  "Resource": [
                    "*"
                  ]
              }
            ] 
          }
          EOF
        }
      }
      dynamic "service_accounts" {
        for_each = var.s3_bucket != null ? [0] : []
        content {
          metadata {
            name      = "velero-rafay"
            namespace = "rafay-system"
          }
          attach_policy = <<EOF
          {
              "Version": "2012-10-17",
              "Statement": [
                  {
                      "Effect": "Allow",
                      "Action": [
                          "ec2:DescribeVolumes",
                          "ec2:DescribeSnapshots",
                          "ec2:CreateTags",
                          "ec2:CreateVolume",
                          "ec2:CreateSnapshot",
                          "ec2:DeleteSnapshot"
                      ],
                      "Resource": "*"
                  },
                  {
                      "Effect": "Allow",
                      "Action": [
                          "s3:GetObject",
                          "s3:DeleteObject",
                          "s3:PutObject",
                          "s3:AbortMultipartUpload",
                          "s3:ListMultipartUploadParts"
                      ],
                      "Resource": [
                          "arn:aws:s3:::${var.s3_bucket}/*"
                      ]
                  },
                  {
                      "Effect": "Allow",
                      "Action": [
                          "s3:ListBucket"
                      ],
                      "Resource": [
                          "arn:aws:s3:::${var.s3_bucket}"
                      ]
                  }
              ]
          }
          EOF
        }
      }
    }
    vpc {
      dynamic "subnets" {
        for_each = var.create_vpc ? {} : {}
        content {
          dynamic "private" {
            for_each = var.private_subnet_ids
            content {
              name = private.value
              id   = private.key
            }
          }
          dynamic "public" {
            for_each = var.public_subnet_ids
            content {
              name = public.value
              id   = public.key
            }
          }
        }
      }
      cluster_endpoints {
        private_access = true
        public_access  = false
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
          key       = managed_nodegroups.value.taint_key
          effect    = managed_nodegroups.value.taint_effect
        }
        labels = managed_nodegroups.value.labels
	    }
    }
    addons {
      name = "aws-ebs-csi-driver"
      version = "latest" 
      configuration_values = "{\"controller\":{\"tolerations\":[{\"key\":\"CriticalAddonsOnly\",\"operator\":\"Exists\"},{\"operator\":\"Exists\"}]}}"
    }
    addons {
      name = "vpc-cni"
      version = "latest"
    }
    addons {
      name = "kube-proxy"
      version = "latest"
    }
    addons {
      name = "coredns"
      version = "latest"
    }
  }
}
