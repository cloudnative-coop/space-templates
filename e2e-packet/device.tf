resource "equinix_metal_reserved_ip_block" "public_network" {
  project_id = var.project
  metro      = data.coder_parameter.metro.value
  quantity   = 1
}

resource "equinix_metal_ip_attachment" "public_ip" {
  device_id     = equinix_metal_device.machine.id
  cidr_notation = join("/", [cidrhost(equinix_metal_reserved_ip_block.public_network.cidr_notation, 0), "32"])
}

resource "equinix_metal_device" "machine" {
  depends_on = [
    acme_certificate.certificate
  ]
  project_id       = var.project
  hostname         = "${lower(data.coder_workspace.ii.owner)}-${lower(data.coder_workspace.ii.name)}"
  metro            = data.coder_parameter.metro.value
  plan             = data.coder_parameter.plan.value
  operating_system = data.coder_parameter.os.value
  user_data = templatefile("cloud-config.yaml.tftpl", {
    username               = "ii"
    elastic_ip             = cidrhost(equinix_metal_reserved_ip_block.public_network.cidr_notation, 0)
    coder_agent_token      = coder_agent.ii.token
    coder_init_script      = base64encode(coder_agent.ii.init_script)
    wildcard_cert_pem      = base64encode(acme_certificate.certificate.certificate_pem)
    wildcard_key_pem       = base64encode(acme_certificate.certificate.private_key_pem)
    audit_policy           = base64encode(file("./etc/kubernetes/pki/audit-policy.yaml"))
    audit_sink             = base64encode(file("./etc/kubernetes/pki/audit-sink.yaml"))
    kubeadm_config         = base64encode(file("./etc/kubernetes/kubeadm-config.yaml"))
    crictl_config          = base64encode(file("./etc/crictl.yaml"))
    containerd_config      = base64encode(file("./etc/containerd/config.toml"))
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
    "name:${data.coder_workspace.ii.owner}-${data.coder_workspace.ii.name}",
    "Space_Provisioned:true"
  ]
}
