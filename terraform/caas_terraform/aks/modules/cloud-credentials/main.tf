resource "rafay_cloud_credential" "credentials" {
  name           = var.cloud_credentials_name
  project        = var.project
  type           = "cluster-provisioning"
  providertype   = "AZURE"
  clientid       = var.client_id
  clientsecret   = var.client_secret
  subscriptionid = var.subscription_id
  tenantid       = var.tenant_id
}