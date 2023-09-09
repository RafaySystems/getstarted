# Poject name variable
project               = "change-me"

# Cloud Credentials specific variables
cloud_credentials_name  = "rafay-cloud-credential"
# Specify Role ARN & externalid info below for AKS.
subscription_id         = "change-me"
tenant_id               = "change-me"
client_id               = "change-me"
client_secret           = "change-me"

# Cluster variables ()
cluster_name           =  "changeme"
# Cluster Location (centralindia)
cluster_location       =  "change-me"
# Cluster Resource Group
cluster_resource_group =  "change-me"
# K8S Version
k8s_version            =  "1.25.6"

# Nodepool sepcific variables
nodePools = {
  "pool1" = {
    name          = "pool1"
    location      = "change-me"
    count         = 1
    maxCount      = 3
    minCount      = 1
    mode          = "System"
    k8sVersion    = "1.25.6"
    vmSize        = "Standard_DS2_v2"
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
base_blueprint_version = "1.28.0"
namespaces              = ["ingress-nginx", "cert-manager"]
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
        service:
          annotations:
            service.beta.kubernetes.io/aws-load-balancer-type: "nlb"
      EOT
    }
}
