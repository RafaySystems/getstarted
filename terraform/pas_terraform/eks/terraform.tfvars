# Poject name variable
project               = "pas-dreta-11-22-2"

# Cloud Credentials specific variables
cloud_credentials_name  = "rafay-cloud-credential"
# Specify Role ARN & externalid info below for EKS.
rolearn                 = "arn:aws:iam::679196758854:role/dreta-provisioning-role"
externalid              = "c685-9ce7-7fbe-c971-5163"

# Cluster variables ()
cluster_name           =  "pas-dreta-11-22-2"
# Cluster Location
cluster_location       =  "us-west-2"
# K8S Version
k8s_version            =  "1.26"

#cluster_admin_iam_roles = 
#["arn:aws:iam::387046989863:role/Broad-access-role"]

cluster_admin_iam_roles = ["arn:aws:iam::679196758854:user/david@rafay.co", "arn:aws:iam::679196758854:role/abhinavm-eks-role", "arn:aws:iam::679196758854:role/km-demo-role"]

# VPC Configuration
private_subnet_ids = {
  "subnet-01bc23afc0744c4aa" = "us-west-2a",
  "subnet-04e1e5616bde25473" = "us-west-2b"
}

# VPC Configuration Public Subnet IDs
public_subnet_ids = {
  "subnet-0cde3009a8e9b04f2" = "us-west-2a",
  "subnet-02d30b8e8c56b142a" = "us-west-2b"
}

# Systems Components Placement
rafay_tol_key         = "node/infra"
rafay_tol_operator    = "Exists"
rafay_tol_effect      = "NoSchedule"
# Daemonset Overrides
ds_tol_key             = "cluster-node"
ds_tol_operator        = "Exists"
ds_tol_effect          = "NoSchedule"

# EKS Nodegroups
managed_nodegroups = {
  "ng-1" = {
    ng_name         = "infra-terraform"
    node_count      = 1
    node_max_count  = 3
    node_min_count  = 1
    k8s_version     = "1.26"
    instance_type   = "t3.large"
    taint_key       = "node/infra"
    taint_operator  = "Exists"
    taint_effect    = "NoSchedule"
  }
}

# TAGS
cluster_tags           = {
    "email" = "email@rafay.co"
    "env"    = "dev"
    "orchestrator" = "rafay"
}
node_tags = {
    "env" = "dev"
}
node_labels = {
    "app" = "infra"
    "dedicated" = "true"
}

# Blueprint/Addons specific variables
blueprint_name         = "custom-blueprint"
blueprint_version      = "v0"
base_blueprint         = "minimal"
base_blueprint_version = "2.1.0"
namespaces             = ["ingress-nginx", "cert-manager"]
infra_addons = {
    "addon1" = {
         name          = "cert-manager"
         namespace     = "cert-manager"
         addon_version = "v1.9.1"
         chart_name    = "cert-manager"
         chart_version = "v1.12.3"
         repository    = "cert-manager"
         file_path     = "file://../artifacts/cert-manager/custom_values.yaml"
         depends_on    = []
    }
    "addon2" = {
         name          = "ingress-nginx"
         namespace     = "ingress-nginx"
         addon_version = "v1.3.1"
         chart_name    = "ingress-nginx"
         chart_version = "4.2.5"
         repository    = "nginx-controller"
         file_path     = null
         depends_on    = ["cert-manager"]
    }
}

constraint_templates   = ["allow-privilege-escalation-container-custom"]

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
}

# Override config
overrides_config = {
    "ingress-nginx" = {
      override_addon_name = "ingress-nginx"
      override_values = <<-EOT
      controller:
        tolerations:
        - key: node/infra
          operator: Exists
          effect: NoSchedule
        - key: cluster-node
          operator: Exists
          effect: NoSchedule

        service:
          annotations:
            service.beta.kubernetes.io/aws-load-balancer-type: "nlb"

        admissionWebhooks:
          patch:
            tolerations:
            - key: node/infra
              operator: Exists
              effect: NoSchedule
            - key: cluster-node
              operator: Exists
              effect: NoSchedule
            # -- Labels to be added to patch job resources

      defaultBackend:
        tolerations:
        - key: node/infra
          operator: Exists
          effect: NoSchedule
        - key: cluster-node
          operator: Exists
          effect: NoSchedule
      EOT
    },
    "cert-manager" = {
      override_addon_name = "cert-manager"
      override_values = <<-EOT
      tolerations:
      - key: node/infra
        operator: Exists
        effect: NoSchedule
      - key: cluster-node
        operator: Exists
        effect: NoSchedule

      webhook:
        tolerations:
        - key: node/infra
          operator: Exists
          effect: NoSchedule
        - key: cluster-node
          operator: Exists
          effect: NoSchedule

      cainjector:
        tolerations:
        - key: node/infra
          operator: Exists
          effect: NoSchedule
        - key: cluster-node
          operator: Exists
          effect: NoSchedule

      startupapicheck:
        tolerations:
        - key: node/infra
          operator: Exists
          effect: NoSchedule
        - key: cluster-node
          operator: Exists
          effect: NoSchedule
      EOT
    }
}
