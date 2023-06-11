resource "equinix_metal_reserved_ip_block" "public_network" {
  project_id = var.project
  metro      = data.coder_parameter.metro.value
  quantity   = 1
}

resource "equinix_metal_ip_attachment" "public_ip" {
  device_id     = equinix_metal_device.machine.id
  cidr_notation = join("/", [local.elastic_ip, "32"])
}

resource "equinix_metal_device" "machine" {
  depends_on = [
    acme_certificate.wildcard
  ]
  project_id       = var.project
  hostname         = local.dns_zone
  metro            = data.coder_parameter.metro.value
  plan             = data.coder_parameter.plan.value
  operating_system = data.coder_parameter.os.value
  user_data = templatefile("cloud-config.yaml", {
    username          = data.coder_workspace.ii.owner
    elastic_ip        = local.elastic_ip
    coder_init_script = base64encode(coder_agent.ii.init_script)
    coder_init_service = base64encode(
      templatefile("./etc/systemd/system/coder-agent.service.tftpl", {
        username          = "ii"
        coder_agent_token = coder_agent.ii.token
    }))
    iipod_manifest = base64encode(
      templatefile("./etc/kubernetes/manifests/iipod.yaml", {
        coder_agent_token = coder_agent.iipod.token
        space_name        = lower(data.coder_workspace.ii.name)
        iipod_image       = data.coder_parameter.container-image.value
    }))
    wildcard_key_pem  = base64encode(acme_certificate.wildcard.private_key_pem)
    wildcard_cert_pem = base64encode("${acme_certificate.wildcard.certificate_pem}${acme_certificate.wildcard.issuer_pem}")
    install_cilium    = base64encode(file("./etc/cloud/install-cilium"))
    crictl_config     = base64encode(file("./etc/crictl.yaml"))
    containerd_config = base64encode(file("./etc/containerd/config.toml"))
    audit_policy      = base64encode(file("./etc/kubernetes/pki/audit-policy.yaml"))
    audit_sink        = base64encode(file("./etc/kubernetes/pki/audit-sink.yaml"))
    kubeadm_config    = base64encode(file("./etc/kubernetes/kubeadm-config.yaml"))
    cilium_manifest   = base64encode(file("./etc/kubernetes/manifests/cilium.yaml"))
    #   snoopdb_manifest     = base64encode(file("./etc/kubernetes/manifests/snoopbd.yaml"))
    #   auditlogger_manifest = base64encode(file("./etc/kubernetes/manifests/auditlogger.yaml"))
    install_nix     = base64encode(file("./etc/cloud/install-nix"))
    nix_config      = base64encode(file("./etc/nix/nix.conf"))
    install_kind    = base64encode(file("./etc/cloud/install-kind"))
    install_desktop = base64encode(file("./etc/cloud/install-desktop"))
    deploy_k8s = base64encode(templatefile("./etc/cloud/deploy-k8s.tftpl", {
      username = "ii"
    }))
    elastic_network_config = base64encode(templatefile("./etc/network/interfaces.d/elastic.tftpl", {
      ip = local.elastic_ip
    }))
    #   # iipod_init_script = base64encode(coder_agent.iipod.init_script)
    #   # iipod_init_script = base64encode(file("./etc/cloud/"))
    #   # iipod_agent_script = base64encode(
    #   #   templatefile("./etc/cloud/iipod-init", {
    #   #     coder_agent_token = coder_agent.iipod.token
    #   # }))
    # deploy_cilium          = base64encode(file("./etc/cloud/deploy-cilium"))
    #   #cilium_config = base64encode(file("./etc/cloud/cilium-values.yaml"))
    # coder_agent_script = coder_agent.iipod.init_script,
    #   iipod_agent_token    = coder_agent.iipod.token
  })
  behavior {
    allow_changes = [
      "user_data"
    ]
  }

  tags = [
    "name:${local.dns_zone}",
  ]
}
