resource "rafay_cloud_credential" "credentials" {
  count          = var.subscription_id == "" ? 0 : 1
  name           = var.cloud_credentials_name
  project        = var.project
  type           = "cluster-provisioning"
  providertype   = "AZURE"
  clientid       = var.client_id
  clientsecret   = var.client_secret
  subscriptionid = var.subscription_id
  tenantid       = var.tenant_id
}

resource "rafay_cloud_credential" "eks-credentials" {
  count        = var.rolearn == "" ? 0 : 1
  name         = var.cloud_credentials_name
  project      = var.project
  type         = "cluster-provisioning"
  providertype = "AWS"
  awscredtype  = "rolearn"
  rolearn      = var.rolearn
  externalid   = var.externalid
}