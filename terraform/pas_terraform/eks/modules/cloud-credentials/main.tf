resource "rafay_cloud_credential" "eks-credentials" {
  name         = var.cloud_credentials_name
  project      = var.project
  type         = "cluster-provisioning"
  providertype = "AWS"
  awscredtype  = "rolearn"
  rolearn      = var.rolearn
  externalid   = var.externalid
}
