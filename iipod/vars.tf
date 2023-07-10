# Needs to be over-wridden in the coder env
data "coder_parameter" "domain" {
  name         = "domain"
  description  = "Power DNS Domain to create iiboxes in"
  display_name = "Domain"
  ephemeral    = false
  icon         = "https://raw.githubusercontent.com/matifali/logos/main/docker.svg"
  mutable      = false
  order        = 1
  type         = "string"
  default      = "sharing.io"
}

data "coder_parameter" "local_ip" {
  name         = "local_ip"
  description  = "Local IP (to the cluster) to allocate to ingress"
  display_name = "Local LB IP"
  ephemeral    = false
  icon         = "https://raw.githubusercontent.com/matifali/logos/main/docker.svg"
  mutable      = false
  order        = 1
  default      = "192.168.1.145"
}

data "coder_parameter" "public_ip" {
  name         = "public_ip"
  display_name = "Public IP"
  description  = "Pbulic IP that has ports 22, 80, 443, and 6443 forwarde to cluster"
  ephemeral    = false
  icon         = "https://raw.githubusercontent.com/matifali/logos/main/docker.svg"
  mutable      = false
  order        = 1
  default      = "90.92.60.248"
}

locals {
  dns_zone          = "${lower(data.coder_workspace.ii.name)}-${lower(data.coder_workspace.ii.owner)}.${data.coder_parameter.domain.value}"
  spacename         = "${lower(data.coder_workspace.ii.name)}-${lower(data.coder_workspace.ii.owner)}"
  dns_fqdn          = "${local.dns_zone}." #adds a "." to the end
  iipod_agent_init  = coder_agent.iipod.init_script
  iipod_agent_token = coder_agent.iipod.token
  local_ip          = data.coder_parameter.local_ip.value
  public_ip         = data.coder_parameter.public_ip.value
  # metal_ip          = equinix_metal_device.iibox.access_public_ipv4
  # iibox_agent_init  = coder_agent.iibox.init_script
  # iibox_agent_token = coder_agent.iibox.token
}
