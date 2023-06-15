# NULL RESOURCE for iipod
# agent_token / startup in local RATHER than directly
# So the NULL resource can point it
# CODER wants agents tied directly to terraform provisioned resources
resource "kubernetes_pod" "iipod" {
  triggers = {
    value = coder_agent.iipod.token
  }
  provisioner "local-exec" {
    command = "echo iipod.token: ${coder_agent.iipod.token}"
  }
  # This isn't actually a kubernetes_pod
  # We use the null.null_resource provider
  # because we don't have the kubeconfig yet
  # https://developer.hashicorp.com/terraform/language/meta-arguments/resource-provider
  provider = null.null_resource
}
