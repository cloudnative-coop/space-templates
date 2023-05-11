resource "kubernetes_pod" "iipod" {
  count = data.coder_workspace.ii.transition == "start" ? 1 : 0
  metadata {
    name      = "${lower(data.coder_workspace.ii.owner)}-${lower(data.coder_workspace.ii.name)}"
    namespace = var.namespace
  }
  spec {
    security_context {
      run_as_user = "0"
      fs_group    = "0"
      # run_as_user = "1001"
      # fs_group    = "1001"
    }
    container {
      name    = "iipod"
      image   = data.coder_parameter.container-image.value
      command = ["sh", "-c", coder_agent.ii.init_script]
      security_context {
        run_as_user = "0"
      }
      env {
        name  = "CODER_AGENT_TOKEN"
        value = coder_agent.ii.token
      }
      volume_mount {
        mount_path = "/nix/store"
        name = "nix-store"
      }
    }
    volume {
      name = "nix-store"
      persistent_volume_claim {
        claim_name = "nix-store"
      }
    }
  }
}
