# Rafay terraform provider examples

This includes examples of Rafay project, group, group_association, cloud_credentials, aks_cluster or eks_cluster, repository, addons, blueprint & cluster overrides.

# Setup

- Update the API key, the API secret, and the Project ID in the Config JSON file.

    - The key, secret, and ID can be found in the RCTL CLI configuration file.
	- In the Console, go to My Tools > Download CLI Config.

```
artifacts/credentials/config.json
```

- Update tfvars file with following variables. Please review other variables and update as required.
```
terraform.tfvars

# Poject name variable
project               = "<PROJECT_NAME>"

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

# Cluster Location (AKS: centralindia, EKS: us-west-2)
cluster_location       =  "<CLUSTER_LOCATION>"

# Cluster specific variables (AKS)
cluster_resource_group =  "<AZURE_RESOURCE_GROUP>"

# TAGS
cluster_tags           = {
    "email" = "user@rafay.co"
    "env"    = "dev"
    "orchestrator" = "rafay"
}
```

- Update any custom values for addons as required.
```
artifacts/ADDON_NAME/
```

## BUILD & RUN

  Execute below command to init with terraform
```
  terraform init
```

  For validating your configuration run below command
```
  terraform validate
```

  If validate is success, that means all the configuration is valid, then we can apply with terraform
```
  terraform apply -var-file=terraform.tfvars
```
  or
```
  terraform apply -var-file=terraform.tfvars -auto-approve
```