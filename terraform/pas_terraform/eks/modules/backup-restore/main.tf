resource "null_resource" "cluster_destroy" {
triggers = {
  proj = var.project
  cluster = var.cluster_name
}
  provisioner "local-exec" {
    when = destroy
    command = "bash -c ${templatefile("modules/backup-restore/delete_resources.sh", {
      PROJECT_NAME="${self.triggers.proj}",
      CLUSTER_NAME="${self.triggers.cluster}"
    } )}"
  }
}

resource "null_resource" "cluster_apply" {
  provisioner "local-exec" {
    when = create
    command = "bash -c ${templatefile("modules/backup-restore/create_resources.sh", {
      PROJECT_NAME="${var.project}",
      CLUSTER_NAME="${var.cluster_name}"
    } )}"
  }
}