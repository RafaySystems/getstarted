# Poject name variable
project               = "<PROJECT_NAME>"

# Cloud Credentials specific variables
cloud_credentials_name  = "rafay-cloud-credential"
# Specify Service prinicipal info below for AKS.
subscription_id         = "<AZURE_SUBSCRIPTION_ID>"
tenant_id               = "<AZURE_TENANT_ID>"
client_id               = "<AZURE_CLIENT_ID>"
client_secret           = "<AZURE_CLIENT_SECRET>"
# Specify Role ARN & externalid info below for EKS.
rolearn                 = "<ROLEARN>"
externalid              = "<EXTERNAL_ID>"

# Cluster variables (Common)
cluster_name           =  "<CLUSTER_NAME>"
# K8S Version (AKS: 1.25.6, EKS: 1.25)
k8s_version            =  "<K8S_VERSION>"
node_count             =  "2"
node_max_count         =  "3"
node_min_count         =  "1"
# Cluster Location (AKS: centralindia, EKS: us-west-2)
cluster_location       =  "<CLUSTER_LOCATION>"

# Cluster specific variables (AKS)
cluster_resource_group =  "<AZURE_RESOURCE_GROUP>"
nodepool_name          =  "rafaynp"
# VM Size for AKS
vm_size                =  "Standard_DS2_v2"

# Cluster specific variables (EKS)
instance_type          = "t3.large"
# EKS Nodegroup 
ng_name                = "rafay-eks-ng"

# TAGS
cluster_tags           = {
    "email" = "user@rafay.co"
    "env"    = "dev"
    "orchestrator" = "rafay"
}
node_tags = {
    "env" = "dev"

}
node_labels = {
    "type" = "aks"
}

# Blueprint/Addons specific variables
blueprint_name         = "custom-blueprint"
blueprint_version      = "v0"
base_blueprint         = "minimal"
base_blueprint_version = "1.25.0"
namespaces              = ["ingress-nginx", "cert-manager"]
infra_addons = {
    "addon1" = {
         name          = "cert-manager"
         namespace     = "cert-manager"
         addon_version = "v1.9.1"
         chart_name    = "cert-manager"
         chart_version = "v1.9.1"
         repository    = "cert-manager"
         file_path     = "file://artifacts/cert-manager/custom_values.yaml"
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
            #For AKS
            service.beta.kubernetes.io/azure-load-balancer-internal: "false"
            #FOR EKS
            #service.beta.kubernetes.io/aws-load-balancer-type: "nlb"
      EOT
    }
}
