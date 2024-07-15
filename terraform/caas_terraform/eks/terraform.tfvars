# Poject name variable
project               = "caas-7-15-1"

# Cloud Credentials specific variables
cloud_credentials_name  = "rafay-cloud-credential"
# Specify Role ARN & externalid info below for EKS.
rolearn                 = "arn:aws:iam::679196758854:role/dreta-full-staging"
externalid              = "05a1-9e93-5019-3368-9669"

# Instance profile Name for Karpenter nodes (Optional: Installs IRSA)
instance_profile       = "arn:aws:iam::679196758854:role/KarpenterNodeRole-Rafay"

# Cluster variables
cluster_name           =  "caas-7-15-1"
# Cluster Region
cluster_location       =  "us-west-2"
# K8S Version
k8s_version            =  "1.28"

# TAGS (Optional)
cluster_tags = {
    "email" = "david@rafay.co"
    "env"    = "dev"
    "orchestrator" = "k8s"
    "cluster-name" = "caas-7-15-1"
}

# S3 bucket name for Backup/Restore (Optional: Installs IRSA & DR components)
/* s3_bucket = ""*/

# K8s cluster labels (Optional)
cluster_labels = {
  "nginx" = "",
  "karpenter" = "",
  "region" = "us-west-2"
}

# IAM Roles to access EKS provided endpoint (Optional)
cluster_admin_iam_roles = ["arn:aws:iam::679196758854:user/david@rafay.co"]

# Allow provisioning of VPC & Subnets
create_vpc = true
/*
# ID and AZ of private subnets (Optional: must have proper permissions to create VPC)
private_subnet_ids = {
  "subnet-001c73a7a4bd8950c" = "us-west-2a",
  "subnet-01199f3894365b393" = "us-west-2b"
}

# ID and AZ of public subnets (optional)
public_subnet_ids = {
  "subnet-0d93f0cf2e0d6e2bd" = "us-west-2a",
  "subnet-09c386bc5800ee067" = "us-west-2b"
}
*/
# Systems Components Placement
rafay_tol_key         = "nodeInfra"
rafay_tol_operator    = "Exists"
rafay_tol_effect      = "NoSchedule"

# EKS Nodegroups
managed_nodegroups = {
  "ng-1" = {
    ng_name         = "infra-terraform"
    node_count      = 1
    node_max_count  = 5
    node_min_count  = 1
    k8s_version     = "1.28"
    instance_type   = "t3.xlarge"
    taint_key       = "nodeInfra"
    taint_operator  = "Exists"
    taint_effect    = "NoSchedule"
    labels          = {
      "node" = "infra"
    }
  }
}

# AWS tags for nodes (Optional)
node_tags = {
  "env" = "dev"
}

# Blueprint/Addons specific variables
blueprint_name         = "custom-blueprint"
blueprint_version      = "v1"
base_blueprint         = "minimal"
base_blueprint_version = "2.7.0"
namespaces             = [
  "ingress-nginx", 
  "cert-manager",
  "karpenter",
  "default",
  "kube-node-lease",
  "kube-public",
  "kube-system",
  "wordpress"
]

# Addons for custom blueprint. (Optional)
infra_addons = {
    "addon1" = {
         name          = "cert-manager"
         namespace     = "cert-manager"
         type          = "Helm"
         addon_version = "v1.12.3.1"
         catalog       = null
         chart_name    = "cert-manager"
         chart_version = "v1.12.3"
         repository    = "cert-manager"
         file_path     = "file://../artifacts/cert-manager/custom_values.yaml"
         depends_on    = []
    }
    "addon2" = {
         name          = "ingress-nginx"
         namespace     = "ingress-nginx"
         type          = "Helm"
         addon_version = "v4.8.3.1"
         catalog       = null
         chart_name    = "ingress-nginx"
         chart_version = "4.8.3"
         repository    = "nginx-controller"
         file_path     = null
         depends_on    = ["cert-manager"]
    }
    "addon3" = {
         name          = "karpenter"
         namespace     = "karpenter"
         type          = "Helm"
         addon_version = "v0.32.1.1"
         catalog       = "default-rafay"
         chart_name    = "karpenter"
         chart_version = "v0.32.1"
         repository    = ""
         file_path     = "file://../artifacts/karpenter/custom_values.yaml"
         depends_on    = ["cert-manager"]
    }
    "addon4" = {
         name          = "karpenter-nodepool"
         namespace     = "karpenter"
         type          = "Yaml"
         addon_version = "v1"
         file_path     = "file://../artifacts/karpenter/nodepool.yaml"
         depends_on    = ["karpenter"]
    }
}

# List of constraints for OPA Policy
constraint_templates   = ["allowed-users-custom",
                          "app-armor-custom",
                          "forbidden-sysctls-custom",
                          "host-filesystem-custom",
                          "host-namespace-custom",
                          "host-network-ports-custom",
                          "linux-capabilities-custom",
                          "privileged-container-custom",
                          "proc-mount-custom",
                          "read-only-root-filesystem-custom",
                          "se-linux-custom",
                          "seccomp-custom",
                          "volume-types-custom",
                          "disallowed-tags-custom",
                          "replica-limits-custom",
                          "required-annotations-custom",
                          "required-labels-custom",
                          "required-probes-custom",
                          "allowed-repos-custom",
                          "block-nodeport-services-custom",
                          "https-only-custom",
                          "image-digests-custom",
                          "container-limits-custom",
                          "container-resource-ratios-custom"]

# repo housing OPA constraints and constraint templates
opa-repo = "rafay-gs"
opa-branch = "master"
opa_excluded_namespaces = ["default", "kube-node-lease", "kube-public", "kube-system"]

# Repository specific variables
public_repositories = {
    "nginx-controller" = {
        type = "Helm"
        endpoint = "https://kubernetes.github.io/ingress-nginx"
    }
    "cert-manager" = {
        type = "Helm"
        endpoint = "https://charts.jetstack.io"
    }
    "rafay-gs" = {
        type = "Git"
        endpoint = "https://github.com/RafaySystems/getstarted.git"
    }
}

# Override config
overrides_config = {
    "ingress-nginx" = {
      override_addon_name = "ingress-nginx"
      override_values = <<-EOT
      defaultBackend:
        resources:
          limits:
            cpu: 10m
            memory: 20Mi
          requests:
            cpu: 10m
            memory: 20Mi
        replicaCount: 3
      commonLabels:
        owner: rafay
      controller:
        admissionWebhooks:
          resources:
            limits:
              cpu: 10m
              memory: 20Mi
            requests:
              cpu: 10m
              memory: 20Mi
        resources:
          limits:
            cpu: 100m
            memory: 90Mi
          requests:
            cpu: 100m
            memory: 90Mi
        service:
          annotations:
            a8r.io/owner: "user@k8s.com"
            a8r.io/runbook: "http://www.k8s.com"
          type: ClusterIP
        tolerations:
        - key: nodeInfra
          operator: Exists
          effect: NoSchedule
        replicaCount: 2
        admissionWebhooks:
          service:
            annotations:
              a8r.io/owner: "user@k8s.com"
              a8r.io/runbook: "http://www.k8s.com"
          patch:
            tolerations:
            - key: nodeInfra
              operator: Exists
              effect: NoSchedule
      defaultBackend:
        tolerations:
        - key: nodeInfra
          operator: Exists
          effect: NoSchedule
      EOT
    },
    "cert-manager" = {
      override_addon_name = "cert-manager"
      override_values = <<-EOT
      tolerations:
      - key: nodeInfra
        operator: Exists
        effect: NoSchedule
      webhook:
        tolerations:
        - key: nodeInfra
          operator: Exists
          effect: NoSchedule
      cainjector:
        tolerations:
        - key: nodeInfra
          operator: Exists
          effect: NoSchedule
      startupapicheck:
        tolerations:
        - key: nodeInfra
          operator: Exists
          effect: NoSchedule
      EOT
    }
    "karpenter" = {
      override_addon_name = "karpenter"
      override_values = <<-EOT
      controller:
        resources:
          requests:
            cpu: 1
            memory: 1Gi
          limits:
            cpu: 1
            memory: 1Gi
      additionalAnnotations:
        a8r.io/owner: "user@k8s.com"
        a8r.io/runbook: "http://www.k8s.com"
      replicas: 1
      tolerations:
      - key: nodeInfra
        operator: Exists
        effect: NoSchedule
      EOT
    }
}