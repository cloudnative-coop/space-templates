resource "coder_metadata" "iipod" {
  resource_id = kubernetes_deployment.iipod[0].id
  count       = data.coder_workspace.ii.start_count
  icon        = "/icon/k8s.png"
  # item {
  #   key   = "ssh"
  #   value = "ssh -tA ii@${powerdns_record.a_record.name} kubectl exec -ti iipod-0 -- tmux at"
  # }
  # item {
  #   key   = "kubexec"
  #   value = "export KUBECONFIG=$(mktemp) ; scp ii@${powerdns_record.a_record.name}:.kube/config $KUBECONFIG ; kubectl exec -ti iipod-0 -- tmux at"
  # }
  # item {
  #   key   = "ssh"
  #   value = "ssh -tA ii@${powerdns_record.a_record.name} kubectl exec -ti iipod-0 -- tmux at"
  # }
  item {
    key   = "emacs"
    value = "https://emacs.${local.space_domain}/"
  }
  item {
    key   = "tmux"
    value = "https://tmux.${local.space_domain}/"
  }
  item {
    key   = "vnc"
    value = "https://vnc.${local.space_domain}/"
  }
  item {
    key   = "web"
    value = "https://web.${local.space_domain}/"
  }
}

resource "kubernetes_deployment" "iipod" {
  wait_for_rollout = false # For use with https://github.com/coder/coder-logstream-kube
  count            = data.coder_workspace.ii.transition == "start" ? 1 : 0
  metadata {
    name = "iipod-${local.spacename}"
    # namespace = "spaces" #var.namespace
    # namespace = "coder" #var.namespace
    # namespace = "${data.coder_workspace.ii.name}-${data.coder_workspace.ii.owner}"
    namespace = local.namespace
    # namespace = "coder" #var.namespace
    labels = {
      "spacename" : local.spacename
    }
  }
  spec {
    # relicas = 1
    selector {
      match_labels = {
        spacename = local.spacename
      }
    }
    template {
      metadata {
        labels = {
          "spacename" : local.spacename
        }
      }
      spec {
        # looks nicer than iipod-tues511-38a8euw3-3t3e8e83s
        hostname             = local.spacename
        service_account_name = "admin"
        security_context {
          run_as_user = "1001"
          fs_group    = "1001"
        }
        container {
          name    = "iipod"
          image   = data.coder_parameter.container-image.value
          command = ["sh", "-c", coder_agent.iipod.init_script]
          security_context {
            run_as_user = "1001"
          }
          env {
            name  = "CODER_AGENT_TOKEN"
            value = coder_agent.iipod.token
          }
        }
      }
    }
  }
  depends_on = [
    null_resource.namespace
    # kubernetes_namespace.space,
    # kubernetes_role.space-admin,
    # kubernetes_role_binding.space-admin,
    # kubernetes_service_account.space-admin
  ]
}
