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
k8s_version            =  "1.22.11"
nodepool_name          =  "pool1"
node_count             =  "2"
node_max_count         =  "3"
node_min_count         =  "1"
vm_size                =  "Standard_DS2_v2"
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

#Blueprint/Addons specific variables
blueprint_name         = "minimal"
blueprint_version      = "1.21.0"