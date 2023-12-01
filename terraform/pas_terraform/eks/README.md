# Project as a Service 

This is Terraform Infrastructure as Code (IaC) supporting a [Getting Started](https://docs.rafay.co/refarch/caas/eks/terraform/overview/) Exercise for "Project as a Service". In this example, we will use Rafay's Terraform Provider to provision an RBAC-controlled, dedicated operating environment aka project for an application team/business unit, bootstrap it with an EKS cluster and bring the cluster to a standardized baseline (aka cluster blueprint). 

---

# Setup

- Update the API key, the API secret, and the Project ID in the Config JSON file.

    - The key, secret, and ID can be found in the RCTL CLI configuration file.
	- In the Console, go to My Tools > Download CLI Config.

```
artifacts/credentials/config.json
```

- Update tfvars file with the following variables. Please review other variables and update as required.
```
terraform.tfvars

# Poject name variable
project               = "<PROJECT_NAME>"

# Specify Role ARN & externalid info below for EKS.
rolearn                 = "<ROLEARN>"
externalid              = "<EXTERNAL_ID>"

# Cluster variables (Common)
cluster_name           =  "<CLUSTER_NAME>"

# K8S Version (EKS: 1.25)
k8s_version            =  "<K8S_VERSION>"

# Cluster Location (EKS: us-west-2)
cluster_location       =  "<CLUSTER_LOCATION>"

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
