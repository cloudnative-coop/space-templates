resource "kubernetes_pod" "iipod" {
  count = data.coder_workspace.ii.transition == "start" ? 1 : 0
  metadata {
    name = "${lower(data.coder_workspace.ii.owner)}-${lower(data.coder_workspace.ii.name)}"
    # namespace = "spaces" #var.namespace
    namespace = "coder" #var.namespace
  }
  spec {
    security_context {
      run_as_user = "1001"
      fs_group    = "1001"
    }
    container {
      name    = "iipod"
      image   = data.coder_parameter.container-image.value
      command = ["sh", "-c", coder_agent.ii.init_script]
      security_context {
        run_as_user = "1001"
      }
      env {
        name  = "CODER_AGENT_TOKEN"
        value = coder_agent.ii.token
      }
    }
  }
}
