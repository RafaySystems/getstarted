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
cluster_name           =  "change-me"
# Cluster Location (centralindia)
cluster_location       =  "change-me"
# Cluster Resource Group
cluster_resource_group =  "change-me"
# K8S Version
k8s_version            =  "1.26.10"

# K8s cluster labels
cluster_labels = {
  "nginx" = "",
  "karpenter" = "",
  "region" = "change-me"
}

# Nodepool sepcific variables
nodePools = {
  "pool1" = {
    name          = "pool1"
    location      = "change-me"
    count         = 1
    maxCount      = 3
    minCount      = 1
    mode          = "System"
    k8sVersion    = "1.26.10"
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
base_blueprint         = "default-aks"
base_blueprint_version = "2.2.0"
namespaces             = ["ingress-nginx", 
                          "cert-manager",
                          "karpenter",
                          "default",
                          "kube-node-lease",
                          "kube-public",
                          "calico-system",
                          "tigera-operator"]
infra_addons = {
    "addon1" = {
         name          = "cert-manager"
         namespace     = "cert-manager"
         type          = "Helm"
         addon_version = "v1.12.3"
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
         addon_version = "v4.8.3"
         catalog       = null
         chart_name    = "ingress-nginx"
         chart_version = "4.8.3"
         repository    = "nginx-controller"
         file_path     = null
         depends_on    = ["cert-manager"]
    }
}

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
                          "container-resource-ratios-custom"
]

# repo housing OPA constraints and constraint templates
opa-repo = "rafay-gs"
opa-branch = "master"
opa_excluded_namespaces = ["calico-system", "tigera-operator", "default", "kube-node-lease", "kube-public", "kube-system"]

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
        replicaCount: 3
        admissionWebhooks:
          service:
            annotations:
              a8r.io/owner: "user@k8s.com"
              a8r.io/runbook: "http://www.k8s.com"
      EOT
    }
}
