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
  user_data = templatefile("cloud-config.yaml.tftpl", {
    username          = data.coder_workspace.ii.owner
    elastic_ip        = local.elastic_ip
    coder_agent_token = coder_agent.ii.token
    coder_init_script = base64encode(coder_agent.ii.init_script)
    # https://registry.terraform.io/providers/vancluever/acme/latest/docs/resources/certificate#attribute-reference
    wildcard_cert_pem      = base64encode("${acme_certificate.wildcard.certificate_pem}${acme_certificate.wildcard.issuer_pem}")
    wildcard_key_pem       = base64encode(acme_certificate.wildcard.private_key_pem)
    audit_policy           = base64encode(file("./etc/kubernetes/pki/audit-policy.yaml"))
    audit_sink             = base64encode(file("./etc/kubernetes/pki/audit-sink.yaml"))
    kubeadm_config         = base64encode(file("./etc/kubernetes/kubeadm-config.yaml"))
    crictl_config          = base64encode(file("./etc/crictl.yaml"))
    containerd_config      = base64encode(file("./etc/containerd/config.toml"))
    nix_config             = base64encode(file("./etc/nix/nix.conf"))
    install_nix            = base64encode(file("./etc/cloud/install-nix"))
    deploy_cilium          = base64encode(file("./etc/cloud/deploy-cilium"))
    install_cilium         = base64encode(file("./etc/cloud/install-cilium"))
    deploy_k8s             = base64encode(templatefile("./etc/cloud/deploy-k8s.tftpl", { username = "ii" }))
    coder_init_service     = base64encode(templatefile("./etc/systemd/system/coder-agent.service.tftpl", { username = "ii", coder_agent_token = coder_agent.ii.token }))
    elastic_network_config = base64encode(templatefile("./etc/network/interfaces.d/elastic.tftpl", { ip = cidrhost(equinix_metal_reserved_ip_block.public_network.cidr_notation, 0) }))
  })
  # custom_data      = local.custom_data
  behavior {
    allow_changes = [
      # "custom_data",
      "user_data"
    ]
  }

  tags = [
    "name:${local.dns_zone}",
    "Space_Provisioned:true"
  ]
}
