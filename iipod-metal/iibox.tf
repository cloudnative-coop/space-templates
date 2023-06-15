resource "equinix_metal_device" "iibox" {
  project_id       = var.project
  hostname         = local.dns_zone
  operating_system = data.coder_parameter.os.value
  plan             = data.coder_parameter.plan.value
  metro            = data.coder_parameter.metro.value
  behavior {
    allow_changes = [
      "user_data"
    ]
  }
  # tags = [
  #   "name:${local.dns_zone}",
  # ]
  # Tried pretty hard to get this working..
  # user_data        = data.cloudinit_config.iibox.rendered
  # Went back to templatefile....
  user_data = templatefile("cloud-config.yaml", {
    username          = data.coder_workspace.ii.owner
    hostname          = lower(data.coder_workspace.ii.name)
    fqdn              = local.dns_zone
    iipod_image       = data.coder_parameter.container-image.value
    coder_init_script = base64encode(coder_agent.iibox.init_script)
    coder_init_service = base64encode(
      templatefile("./templates/etc/systemd/system/coder-agent.service", {
        coder_agent_user  = "ii"
        coder_agent_token = coder_agent.iibox.token
    }))
    # wildcard_key_pem  = base64encode(acme_certificate.wildcard.private_key_pem)
    # wildcard_cert_pem = base64encode("${acme_certificate.wildcard.certificate_pem}${acme_certificate.wildcard.issuer_pem}")
    audit_policy      = base64encode(file("./etc/kubernetes/pki/audit-policy.yaml"))
    audit_sink        = base64encode(file("./etc/kubernetes/pki/audit-sink.yaml"))
    install_cilium    = base64encode(file("./etc/cloud/install-cilium"))
    crictl_config     = base64encode(file("./etc/crictl.yaml"))
    containerd_config = base64encode(file("./etc/containerd/config.toml"))
    kubeadm_config    = base64encode(file("./etc/kubernetes/kubeadm-config.yaml"))
    install_nix       = base64encode(file("./etc/cloud/install-nix"))
    install_flux      = base64encode(file("./etc/cloud/install-flux"))
    nix_config        = base64encode(file("./etc/nix/nix.conf"))
    install_kind      = base64encode(file("./etc/cloud/install-kind"))
    install_desktop   = base64encode(file("./etc/cloud/install-desktop"))
    deploy_cilium     = base64encode(file("./etc/cloud/deploy-cilium"))
    # ips_manifest = base64encode(
    #   templatefile("./etc/kubernetes/manifests/ips.yaml", {
    #     ip = local.elastic_ip
    # }))
    values_cilium = base64encode(
      templatefile("./templates/etc/cloud/values-cilium.yaml", {
        k8s_service_host = local.dns_zone
    }))
    deploy_k8s = base64encode(
      templatefile("./templates/etc/cloud/deploy-k8s", {
        username = "ii"
    }))
    iipod_manifest = base64encode(
      templatefile("./templates/etc/kubernetes/manifests/iipod.yaml", {
        coder_agent_token = local.iipod_agent_token
        space_name        = lower(data.coder_workspace.ii.name)
        iipod_image       = data.coder_parameter.container-image.value
    }))
  })
}
