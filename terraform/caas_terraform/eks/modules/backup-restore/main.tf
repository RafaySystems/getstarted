resource "null_resource" "cluster_destroy" {
  count = var.s3_bucket != null ? 1 : 0
  triggers = {
    proj              = var.project
    cluster           = var.cluster_name
    s3_bucket         = var.s3_bucket
    cluster_location  = var.cluster_location
  }
  provisioner "local-exec" {
    when = destroy
    command = "bash -c ${templatefile("modules/backup-restore/delete_resources.sh", {
      PROJECT_NAME="${self.triggers.proj}",
      CLUSTER_NAME="${self.triggers.cluster}"
      S3_BUCKET_NAME="${self.triggers.s3_bucket}"
      CLUSTER_LOCATION="${self.triggers.cluster_location}"
    } )}"
  }
}

resource "null_resource" "cluster_apply" {
  count = var.s3_bucket != null ? 1 : 0
  provisioner "local-exec" {
    when = create
    command = "bash -c ${templatefile("modules/backup-restore/create_resources.sh", {
      PROJECT_NAME="${var.project}",
      CLUSTER_NAME="${var.cluster_name}"
      S3_BUCKET_NAME="${var.s3_bucket}"
      CLUSTER_LOCATION="${var.cluster_location}"
    } )}"
  }
}