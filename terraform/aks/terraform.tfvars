#Project name variable
project               = "terraform"

#Cloud Credentials specific variables
cloud_credentials_name  = "aks-cloud-credentials"
subscription_id         = "<SUBSCRIPTION_ID>"
tenant_id               = "<TENANT_ID>"
client_id               = "<CLIENT_ID>"
client_secret           = "<CLIENT_SECRET>"

#Cluster specific variables
cluster_name           =  "aks-cluster"
cluster_resource_group =  "<RESOURCE_GROUP_NAME>"
cluster_location       =  "centralindia"
k8s_version            =  "1.23.8"

#Blueprint/Addons specific variables
blueprint_name         = "minimal"
blueprint_version      = "1.21.0"

#Nodepool sepcific variables
nodePools = {
  "pool1" = {
    name          = "pool1"
    location      = "centralindia"
    count         = 2
    maxCount      = 3
    minCount      = 2
    mode          = "System"
    k8sVersion    = "1.23.8"
    vmSize        = "Standard_DS2_v2"
  }
  "pool2" = {
    name          = "pool2"
    location      = "centralindia"
    count         = 1
    maxCount      = 3
    minCount      = 1
    mode          = "User"
    k8sVersion    = "1.23.8"
    vmSize        = "Standard_DS2_v2"
  }
}