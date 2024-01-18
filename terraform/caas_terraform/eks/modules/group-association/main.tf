resource "rafay_groupassociation" "groupassociation" {
  group      = var.group
  project    = var.project
  roles      = ["PROJECT_ADMIN"]
}