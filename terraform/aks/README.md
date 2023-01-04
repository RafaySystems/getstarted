# Rafay terraform provider examples

This Getting Started exercise uses Terraform with Azure AKS to provision a cluster. You can view your results in the Console.

For more exercises, go to the [Documentation site](https://docs.rafay.co/learn/quickstart/aks/clusterlifecycle/overview/) to see the following:

- Provisiong a cluster
- Scaling the number of nodes
- Adding a node group
- Upgrading the Kubernetes version for the cluster
- Deprovisiong (deleting) a cluster

# Setup

- Update API key, the API secret, and the Project ID in the Config JSON file.

    - The key, secret, and ID can be found in the RCTL CLI configuration file.
	- In the Console, go to My Tools > Download CLI Config.

```
artifacts/credentials/config.json
```

- Update tfvars file with following variables. Please review other variables and update as required.
- Note: For the purposes of this exercise, the number of variables has been limited.

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


## BUILD & RUN

Use the following command to init with Terraform.

```
terraform init
```

Use the following command to validate your configuration.

```
terraform validate
```

If validation is successful, use the following command to apply the cluster configuration using Terraform.

```
terraform apply
```
