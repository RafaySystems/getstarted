#Poject name variable
project               = "terraform"

#Cloud Credentials specific variables
cloud_credentials_name  = "cloud-credentials-name"
rolearn                 = "<ROLEARN>"
externalid              = "<EXTERNAL_ID>"

#Cluster specific variables
cluster_name           =  "eks-cluster"
cluster_location       =  "<CLUSTER_LOCATION/REGION>"
k8s_version            =  "<K8S_VERSION>"

#Blueprint/Addons specific varaibles
blueprint_name         = "minimal"
blueprint_version      = "1.21.0"

#Nodepool specific variables
managed_nodegroups = {
  "pool1" = {
    ng_name         = "pool1"
    location        = "<CLUSTER_LOCATION/REGION>"
    node_count      = 1
    node_max_count  = 3
    node_min_count  = 1
    k8s_version     = "<K8S_VERSION>"
    instance_type   = "t3.xlarge"
  }
}
