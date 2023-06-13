# Rafay terraform provider examples

This includes examples of Rafay project, cloud_credentials, aks_cluster, repository, addons, blueprint & cluster overrides.

# Setup

- Update Rafay API & SECRET
```
artifacts/credentials/config.json
```

- Update tfvars file with following variables. Please review other variables and update as required.
```
terraform.tfvars

#Poject name variable
project                 = "<PROJECT_NAME>"

#Cloud Credentials specific varaibles
cloud_credentials_name  = "<CLOUD_CREDENTIAL_NAME>"
subscription_id         = "<SUBSCRIPTION_ID>"
tenant_id               = "<TENANT_ID>"
client_id               = "<CLIENT_ID>"
client_secret           = "<CLIENT_SECRET>"

#Cluster specific varaibles
cluster_name           =  "<CLUSTER_NAME>"
cluster_resource_group =  "<RESOURCE_GROUP_NAME>"
cluster_location       =  "<CLUSTER_LOCATION>"
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