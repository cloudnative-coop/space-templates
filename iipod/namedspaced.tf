resource "template_dir" "persistent" {
  source_dir      = "${path.module}/persistent_manifests"
  destination_dir = "${path.cwd}/persistent_manifests"
  vars = {
    namespace   = local.namespace
    user_domain = local.user_domain
  }
}

resource "template_dir" "ephemeral" {
  source_dir      = "${path.module}/ephemeral_manifests"
  destination_dir = "${path.cwd}/ephemeral_manifests"
  vars = {
    namespace    = local.namespace
    user_domain  = local.user_domain
    space_name   = local.space_name
    space_domain = local.space_domain
  }
}

resource "null_resource" "namespace" {
  # I want to apply a bunch of manifests at once
  # I encouge you to find a faster way
  provisioner "local-exec" {
    command = <<COMMAND
set -x
set -e
./kubectl version --client || (
  echo installing kubectl:
  curl -L https://dl.k8s.io/release/v1.27.3/bin/linux/amd64/kubectl -o ./kubectl \
  && chmod +x ./kubectl
)
COMMAND
  }
  # We have manifests to create the namespace and persist a few things
  provisioner "local-exec" {
    # - the main *.user.DOMAIN cert
    command = <<COMMAND
set -x
set -e
./kubectl apply -f ./persistent_mannifests/
COMMAND
  }
  # We have manifests to create the namespace
  provisioner "local-exec" {
    command = <<COMMAND
set -x
set -e
./kubectl apply -f ./ephemeral_mannifests/
COMMAND
  }
  # We could also deloy logstream-kube to show the pod coming up...
  #   provisioner "local-exec" {
  #     command = <<COMMAND
  # ~/helm version --short || (
  #   echo installing helm:
  #   curl -L https://get.helm.sh/helm-v3.12.1-linux-amd64.tar.gz | tar xvz --strip-components=1 \
  #   && mv helm ~/helm \
  #   && chmod +x ~/helm
  # )
  # COMMAND
  #   }
  # provisioner "local-exec" {
  #   command = "~/kubectl -n ${local.namespace} apply -f ${path.module}/manifests/admin-sa.yaml"
  # }
  #   provisioner "local-exec" {
  #     command = <<COMMAND
  # ~/helm upgrade --install \
  #   --repo https://helm.coder.com/logstream-kube \
  #   --namespace ${local.namespace} \
  #   --set url=${var.coder_url} \
  #   coder-logstream-kube coder-logstream-kube
  # COMMAND
  #   }
}
resource "coder_metadata" "namespace" {
  resource_id = null_resource.namespace.id
  count       = data.coder_workspace.ii.start_count
  icon        = "/icon/k8s.png"
  # hide        = true
}
