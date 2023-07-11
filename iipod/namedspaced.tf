resource "null_resource" "namespace" {
  # Pour man's GET IT DONE
  provisioner "local-exec" {
    command = <<COMMAND
~/kubectl version --client || (
  echo installing kubectl:
  curl -L https://dl.k8s.io/release/v1.27.3/bin/linux/amd64/kubectl -o ~/kubectl \
  && chmod +x ~/kubectl
)
COMMAND
  }
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
  provisioner "local-exec" {
    command = "~/kubectl create ns ${local.namespace} || true"
  }
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
  provisioner "local-exec" {
    command = <<COMMAND
cat <<MANIFEST | ~/kubectl apply --namespace ${local.namespace} -f -
---
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: wildcard
spec:
  secretName: wildcard-tls
  dnsNames:
    - "${local.user_domain}"
    - "*.${local.user_domain}"
  issuerRef:
    name: letsencrypt
    kind: ClusterIssuer
    group: cert-manager.io
---
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: ${local.spacename}-wildcard-tls
  labels:
    spacename: ${local.spacename}
spec:
  secretName: ${local.spacename}-wildcard-tls
  dnsNames:
    - "${local.space_domain}"
    - "*.${local.space_domain}"
  issuerRef:
    name: letsencrypt
    kind: ClusterIssuer
    group: cert-manager.io
MANIFEST
COMMAND
  }
  # ---
  # apiVersion: source.toolkit.fluxcd.io/v1
  # kind: GitRepository
  # metadata:
  #   name: itscontained
  #   namespace: flux-system
  # spec:
  #   interval: 24h
  #   url: https://github.com/itscontained/charts
  #   ref:
  #     branch: canon
  #   ignore: |-
  # exclude all
  #    /*
  # include charts directory
  #    !/itscontained/raw/
  #   provisioner "local-exec" {
  #     command = <<COMMAND
  # cat <<MANIFEST | ~/kubectl apply --namespace ${local.namespace} -f -
  # MANIFEST
  # COMMAND
  #   }
}
resource "coder_metadata" "namespace" {
  resource_id = null_resource.namespace.id
  count       = data.coder_workspace.ii.start_count
  icon        = "/icon/k8s.png"
  hide        = true
}
# apiVersion:
# kind:
# metadata:
#   name: ${local.spacename}
#   labels:
#     spacename: ${local.spacename}
# spec:
#   interval: 30m
#   releaseName: ${local.spacename}
#   chart:
#     spec:
#       chart: itscontained/raw
#       sourceRef:
#         kind: GitRepository
#         name: itscontained
#         namespace: flux-system
#   values:
#     resources:
#       %{for path in fileset(path.module, "manifests/templates/*yaml")~}
#       - ${indent(2, templatefile(path, { spacename = local.spacename, space_domain = local.space_domain }))}
#       %{endfor~}
# }
# resource "kubernetes_manifest" "test-configmap" {
#   manifest = {
#     "apiVersion" = "helm.toolkit.fluxcd.io/v2beta1"
#     "kind"       = "HelmRelease"
#     "metadata" = {
#       "name"      = "test-config"
#       "namespace" = "default"
#     }
#     "data" = {
#       "foo" = "bar"
#     }
#   }
# }
# resource "helm_release" "iipod" {
#   name       = "iipod-${local.spacename}"
#   repository = "https://charts.itscontained.io"
#   chart      = "raw"
#   version    = "0.2.5"
#   values = [
#     <<-EOF
#     resources:
#       %{for path in fileset(path.module, "manifests/templates/*yaml")~}
#       - ${indent(2, templatefile(path, { spacename = local.spacename, space_domain = local.space_domain }))}
#       %{endfor~}
#     EOF
#   ]
# }

# output "iiyaml" {
#   value = <<OUTPUT
# %{for path in fileset(path.module, "manifests/templates/*yaml")~}
# - ${indent(2, templatefile(path, { spacename = local.spacename, space_domain = local.space_domain }))}
# %{endfor~}
# OUTPUT
# }
