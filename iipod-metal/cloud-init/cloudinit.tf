data "cloudinit_config" "iibox" {
  gzip          = false
  base64_encode = false
  part {
    content_type = "text/cloud-config"
    content = templatefile("${path.module}/cloud-init/config.yaml",
      {
        # username = local.username
        # hostname = local.hostname
        # coder_init_script = base64encode(coder_agent.iibox.init_script)
        # coder_init_service = base64encode(
        #   templatefile("${path.module}/cloud-init/files/etc/systemd/system/coder-agent.service.tftpl", {
        #     username          = "ii"
        #     coder_agent_token = coder_agent.iibox.token
        # }))

        # wildcard_key_pem = base64encode(acme_certificate.wildcard.private_key_pem)
        # wildcard_cert_pem = base64encode("${acme_certificate.wildcard.certificate_pem}${acme_certificate.wildcard.issuer_pem}")
        # audit_policy      = base64encode(file("./etc/kubernetes/pki/audit-policy.yaml"))
        # audit_sink        = base64encode(file("./etc/kubernetes/pki/audit-sink.yaml"))
      }
    )
  }
  part {
    content_type = "text/cloud-config"
    content      = <<-EOT
      groups:
        - docker
      # Create ii user as part of docker group
      users:
        - name: git
        - name: ii
          sudo: ["ALL=(ALL) NOPASSWD:ALL"]
          groups: "sudo, docker"
          shell: /bin/bash
          ssh_redirect_user: true
          # FIXME:
          # ssh_import_id:
          #   - gh:$${username}
    EOT
  }
  part {
    content_type = "text/cloud-config"
    content      = <<-EOT
      debconf_selections: |
        debconf
        debconf apt-fast/maxdownloads string 32
        debconf apt-fast/dlflag boolean true
        debconf apt-fast/aptmanager string apt-get
    EOT
  }
  part {
    content_type = "text/cloud-config"
    content      = <<-EOT
      apt:
        sources:
          docker.list:
            source: "deb https://download.docker.com/linux/ubuntu $RELEASE stable"
            keyid: 9DC858229FC7DD38854AE2D88D81803C0EBFCD88
    EOT
  }
  part {
    content_type = "text/cloud-config"
    content      = <<-EOT
      write_files:
        - path: /usr/local/bin/coder-agent-init.sh
          content: ${base64encode(coder_agent.iibox.init_script)}
          permissions: "0755"
          encoding: b64
    EOT
  }
  part {
    content_type = "text/cloud-config"
    content = <<-EOT
      write_files:
        - path: /etc/systemd/system/coder-agent.service
          content: ${templatefile(
    "${path.module}/templates/etc/systemd/system/coder-agent.service", {
      coder_agent_user = "ii",
coder_agent_token = coder_agent.iibox.token })}
          permissions: "0755"
          encoding: b64
    EOT
}
}
# coder_init_script = base64encode(coder_agent.iibox.init_script)
# part {
#   filename     = ""
#   content_type = "text/x-shellscript"
#   content      = coder_agent.iibox.init_script
# }
# part {
#   filename     = "/etc/systemd/system/coder-agent.service"
#   content_type = "text/plain"
#   content = templatefile(
#     "${path.module}/templates/etc/systemd/system/coder-agent.service", {
#       coder_agent_user  = "ii"
#       coder_agent_token = coder_agent.iibox.token
#   })
# }
# part {
#   filename     = "/etc/wildcard.cert.pem"
#   content_type = "text/plain"
#   content      = "${acme_certificate.wildcard.certificate_pem}${acme_certificate.wildcard.issuer_pem}"
# }
# part {
#   filename     = "/etc/wildcard.key.pem"
#   content_type = "text/plain"
#   content      = acme_certificate.wildcard.private_key_pem
# }
