#Poject name variable
project                 = "terraform"

#Cloud Credentials specific varaibles
cloud_credentials_name  = "cloud-credentials-name"
rolearn                 = "<ROLE_ARN>"
externalid              = "<EXTERNAL_ID>"

#Cluster specific varaibles
cluster_name           =  "eks-cluster"
cluster_location       =  "<CLUSTER_LOCATION/REGION>"
k8s_version            =  "1.22"
nodepool_name          =  "pool1"
node_count             =  "1"
node_max_count         =  "3"
node_min_count         =  "1"
ng_name                = "pool1"
instance_type          = "t3.xlarge"
cluster_tags           = {
    "created-by" = "user"
    "to-test"    = "terraform"
}
node_tags              = {
    "env" = "prod"
}
node_labels            = {
    "type" = "eks"
}

#Blueprint/Addons specific varaibles
blueprint_name         = "minimal"
blueprint_version      = "1.21.0"
