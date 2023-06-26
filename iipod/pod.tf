resource "coder_metadata" "iipod" {
  resource_id = kubernetes_pod.iipod[0].id
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
    value = "http://emacs.${local.dns_zone}/"
  }
  item {
    key   = "tmux"
    value = "http://tmux.${local.dns_zone}/"
  }
  item {
    key   = "vnc"
    value = "http://vnc.${local.dns_zone}/"
  }
  item {
    key   = "web"
    value = "http://web.${local.dns_zone}/"
  }
}

resource "kubernetes_pod" "iipod" {
  count = data.coder_workspace.ii.transition == "start" ? 1 : 0
  metadata {
    name = local.spacename
    # namespace = "spaces" #var.namespace
    # namespace = "coder" #var.namespace
    # namespace = "${data.coder_workspace.ii.name}-${data.coder_workspace.ii.owner}"
    namespace = local.spacename
    # namespace = "coder" #var.namespace
    labels = {
      "spacename" : data.coder_workspace.ii.name
      "spaceowner" : data.coder_workspace.ii.owner
    }
  }
  spec {
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
  depends_on = [
    kubernetes_namespace.space,
    kubernetes_role.space-admin,
    kubernetes_role_binding.space-admin,
    kubernetes_service_account.space-admin
  ]
}
