resource "null_resource" "namespace" {
  # triggers = {
  #   value = coder_agent.iipod.token
  # }
  # install kubectl
  provisioner "local-exec" {
    command = "~/kubectl version --client || (curl -L https://dl.k8s.io/release/v1.27.3/bin/linux/amd64/kubectl -o ~/kubectl && chmod +x ~/kubectl)"
  }
  provisioner "local-exec" {
    command = "~/kubectl create ns ${local.spacename}"
  }
  provisioner "local-exec" {
    command = "~/kubectl -n ${local.spacename} apply -f ${path.module}/manifests/admin-sa.yaml"
  }
}
# resource "local_file" "namedspace" {
#   content  = file("./manifests/admin-sa.yaml")
#   filename = "${path.module}/foo.bar"
# }
# resource "local_file" "namedspace" {
#   content  = file("./manifests/admin-sa.yaml")
#   filename = "${path.module}/foo.bar"
# }
