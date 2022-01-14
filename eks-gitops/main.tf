resource "null_resource" "cluster" {
  provisioner "local-exec" {
    interpreter = ["/bin/bash","-c"]
    command = "chmod +x rafay_eks_provision.sh ; ./rafay_eks_provision.sh"
  }
}
