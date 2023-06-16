# https://deploy.equinix.com/developers/docs/metal/locations/capacity/#checking-capacity
# We may want to check capacity now and then
# metal capacity get -P c3.small.x86 | grep normal
# | ny5  | c3.small.x86 | normal      |
# | ny7  | c3.small.x86 | normal      |
# | sv15 | c3.small.x86 | normal      |
# | sv16 | c3.small.x86 | normal      |
# | ty11 | c3.small.x86 | normal      |
# Then updateplans
data "coder_parameter" "metro" {
  name         = "metro"
  display_name = "Metro"
  description  = "The Equinix Metal Metro for the machine"
  default      = "ny"
  icon         = "https://raw.githubusercontent.com/matifali/logos/main/docker.svg"
  option {
    name  = "New York, USA"
    value = "ny"
    icon  = "https://upload.wikimedia.org/wikipedia/commons/thumb/b/ba/Flag_of_New_York_City.svg/2560px-Flag_of_New_York_City.svg.png"
  }
  option {
    name  = "Silicon Valley, USA"
    value = "sv"
    icon  = "https://upload.wikimedia.org/wikipedia/commons/thumb/0/0e/Ingenico_Healthcare_ORGA_6041_-_LAN_Modul_6000.0_-_BCP51-4797.jpg/1920px-Ingenico_Healthcare_ORGA_6041_-_LAN_Modul_6000.0_-_BCP51-4797.jpg"
  }
  option {
    name  = "Tokyo, Japan"
    value = "ty"
    icon  = "https://upload.wikimedia.org/wikipedia/en/thumb/9/9e/Flag_of_Japan.svg/320px-Flag_of_Japan.svg.png"
  }
  option {
    name  = "Frankfurt, Germany"
    value = "fr"
    icon  = "https://upload.wikimedia.org/wikipedia/en/thumb/b/ba/Flag_of_Germany.svg/2560px-Flag_of_Germany.svg.png"
  }
  option {
    name  = "Dallas, Texas, USA"
    value = "da"
    icon  = "https://upload.wikimedia.org/wikipedia/commons/thumb/f/f7/Flag_of_Texas.svg/1200px-Flag_of_Texas.svg.png"
  }
  option {
    name  = "Sydney, Australia"
    value = "sy"
    icon  = "https://upload.wikimedia.org/wikipedia/commons/thumb/8/88/Flag_of_Australia_%28converted%29.svg/2560px-Flag_of_Australia_%28converted%29.svg.png"
  }
  option {
    name  = "Washington, DC, USA"
    value = "dc"
    icon  = "https://upload.wikimedia.org/wikipedia/commons/thumb/a/a9/Flag_of_the_United_States_%28DoS_ECA_Color_Standard%29.svg/1200px-Flag_of_the_United_States_%28DoS_ECA_Color_Standard%29.svg.png"
  }
}

data "coder_parameter" "plan" {
  name         = "plan"
  display_name = "Plan"
  description  = "The Equinix Metal Plan for the machine"
  default      = "c3.small.x86"
  option {
    name  = "c3.small.x86"
    value = "c3.small.x86"
  }
  option {
    name  = "c3.medium.x86"
    value = "c3.medium.x86"
  }
  option {
    name  = "m3.large.x86"
    value = "m3.large.x86"
  }
}

data "coder_parameter" "os" {
  name         = "os"
  display_name = "Operating System"
  description  = "The Equinix Metal Operating System for the machine"
  default      = "ubuntu_22_04"
  option {
    name  = "Ubuntu 20.04 LTS"
    value = "ubuntu_20_04"
  }
  option {
    name  = "Ubuntu 22.04 LTS"
    value = "ubuntu_22_04"
  }
}

resource "coder_agent" "iibox" {
  auth                    = "token"
  arch                    = "amd64" # Intel
  os                      = "linux" # Linux
  dir                     = "$HOME" # Could set to somewhere
  motd_file               = "/etc/motd"
  startup_script_behavior = "blocking"     # blocking, non-blocking
  troubleshooting_url     = "http://ii.nz" # blocking, non-blocking
  connection_timeout      = 300
  startup_script          = file("./iibox-startup.sh")
  startup_script_timeout  = 300
  shutdown_script         = "#!/bin/sh\necho Box is on it's way down!"
  shutdown_script_timeout = 300
  env = {
    # GITHUB_TOKEN        = "$${data.coder_git_auth.github.access_token}"
    # GITHUB_TOKEN        = "$${var.GITHUB_TOKEN}"
    ORGURL              = data.coder_parameter.org-url.value
    SESSION_NAME        = "${lower(data.coder_workspace.ii.name)}"
    GIT_AUTHOR_NAME     = "${data.coder_workspace.ii.owner}"
    GIT_COMMITTER_NAME  = "${data.coder_workspace.ii.owner}"
    GIT_AUTHOR_EMAIL    = "${data.coder_workspace.ii.owner_email}"
    GIT_COMMITTER_EMAIL = "${data.coder_workspace.ii.owner_email}"
  }
  metadata {
    interval = 10
    key      = "k8s"
    script   = "kubectl version -o json | jq '.serverVersion.gitVersion' -r"
  }
  # metadata {
  #   interval = 10
  #   key      = "kubeconfig"
  #   script   = "cat ~/.kube/config"
  # }
}

# ttyd connecting to tmux
resource "coder_app" "tmux" {
  subdomain    = true
  share        = "public"
  slug         = "tmux"
  display_name = "TMUX"
  icon         = "https://cdn.icon-icons.com/icons2/2148/PNG/512/tmux_icon_131831.png"
  agent_id     = coder_agent.iibox.id
  url          = "http://localhost:7681" # 7681 is the default ttyd port
}

# # noVNC connecting to tigervnc:1
resource "coder_app" "vnc" {
  subdomain    = true
  share        = "public"
  slug         = "vnc"
  display_name = "VNC:1"
  icon         = "/icon/novnc.svg"
  agent_id     = coder_agent.iibox.id
  url          = "http://localhost:6080?resize=remote&autoconnect=true"
}


resource "coder_metadata" "iibox" {
  resource_id = equinix_metal_device.iibox.id
  count       = data.coder_workspace.ii.start_count
  icon        = "https://avatars.githubusercontent.com/u/7982021?s=280&v=4"
  item {
    key   = "ssh"
    value = "ssh -tA ii@${powerdns_record.wild_a_record.name}.${powerdns_record.wild_a_record.zone} tmux at"
  }
  item {
    key   = "kubeconfig"
    value = "export KUBECONFIG=$(mktemp) ; scp ii@${powerdns_record.wild_a_record.name}.${powerdns_record.wild_a_record.zone}:.kube/config $KUBECONFIG"
  }
}

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
    wildcard_key_pem          = base64encode(acme_certificate.wildcard.private_key_pem)
    wildcard_cert_pem         = base64encode("${acme_certificate.wildcard.certificate_pem}${acme_certificate.wildcard.issuer_pem}")
    nginx_flux_manifest       = base64encode(file("./cluster/nginx.yaml"))
    istio_flux_manifest       = base64encode(file("./cluster/istio.yaml"))
    apisnoop_flux_manifest    = base64encode(file("./cluster/apisnoop.yaml"))
    certmanager_flux_manifest = base64encode(file("./cluster/cert-manager.yaml"))
    audit_policy              = base64encode(file("./etc/kubernetes/pki/audit-policy.yaml"))
    audit_sink                = base64encode(file("./etc/kubernetes/pki/audit-sink.yaml"))
    install_cilium            = base64encode(file("./etc/cloud/install-cilium"))
    crictl_config             = base64encode(file("./etc/crictl.yaml"))
    containerd_config         = base64encode(file("./etc/containerd/config.toml"))
    kubeadm_config            = base64encode(file("./etc/kubernetes/kubeadm-config.yaml"))
    install_nix               = base64encode(file("./etc/cloud/install-nix"))
    install_flux              = base64encode(file("./etc/cloud/install-flux"))
    nix_config                = base64encode(file("./etc/nix/nix.conf"))
    install_kind              = base64encode(file("./etc/cloud/install-kind"))
    install_desktop           = base64encode(file("./etc/cloud/install-desktop"))
    deploy_cilium             = base64encode(file("./etc/cloud/deploy-cilium"))
    # ips_manifest = base64encode(
    #   templatefile("./etc/kubernetes/manifests/ips.yaml", {
    #     ip = local.elastic_ip
    # }))
    ingress_manifest = base64encode(
      templatefile("./templates/etc/kubernetes/manifests/ingress.yaml", {
        fqdn = local.dns_zone
    }))
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
        fqdn              = local.dns_zone
        coder_agent_token = local.iipod_agent_token
        space_name        = lower(data.coder_workspace.ii.name)
        iipod_image       = data.coder_parameter.container-image.value
    }))
    # patched_nginx_manifest = base64encode(
    #   templatefile("./templates/etc/kubernetes/manifests/patched-nginx.yaml", {
    #     ip =
    # }))
  })
}
