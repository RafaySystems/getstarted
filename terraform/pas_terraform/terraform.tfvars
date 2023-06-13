# Poject name variable
project               = "my-terraform-project"

# Cloud Credentials specific variables
cloud_credentials_name  = "cloud-credentials"
# Specify Service prinicipal info below for AKS.
subscription_id         = "a2252eb2-7a25-432b-a5ec-e18eba6f26b1"
tenant_id               = "38d77531-9d10-484f-9c1d-3e3484cd9c34"
client_id               = "968ce636-d857-4d58-a4d5-301b232fa3f5"
client_secret           = "PMG7Q~54T1Y6.naxP7KGlYrEIMzvHdCOqAkHR"
# Specify Role ARN & externalid info below for EKS.
rolearn                 = ""
externalid              = ""

# Cluster variables (Common)
cluster_name           =  "dreta-aks-cluster-6-12-1"
k8s_version            =  "1.25.6"
node_count             =  "2"
node_max_count         =  "3"
node_min_count         =  "1"
# Azure Region
cluster_location       =  "centralindia"
# AWS Region
#cluster_location       =  "us-west-2"

# Cluster specific variables (AKS)
cluster_resource_group =  "dreta-private"
nodepool_name          =  "rafay-aks-nodepool"
# VM Size for AKS
vm_size                =  "Standard_DS2_v2"

# Cluster specific variables (EKS)
instance_type          = "t3.xlarge"
# EKS Nodegroup 
ng_name                = "rafay-eks-ng"

# Cluster Sharing
sharing = false

# TAGS
cluster_tags           = {
    "created-by" = "user"
    "to-test"    = "terraform"
}
node_tags = {
    "env" = "prod"

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