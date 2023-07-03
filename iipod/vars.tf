# Needs to be over-wridden in the coder env
variable "domain" {
  type        = string
  description = "Power DNS Domain to create iiboxes in"
  default     = "cloudnative.nz" # pair.sharing.io
}

variable "lb_ip" {
  type        = string
  description = "Local LB IP"
  default     = "192.168.1.145"
}
variable "public_ip" {
  type        = string
  description = "Public IP"
  default     = "46.121.145.229"
}

locals {
  dns_zone          = "${lower(data.coder_workspace.ii.name)}-${lower(data.coder_workspace.ii.owner)}.${var.domain}"
  dns_fqdn          = "${local.dns_zone}." #adds a "." to the end
  iipod_agent_init  = coder_agent.iipod.init_script
  iipod_agent_token = coder_agent.iipod.token
  lb_ip             = var.lb_ip
  public_ip         = var.public_ip
  spacename         = "${lower(data.coder_workspace.ii.name)}-${lower(data.coder_workspace.ii.owner)}"
  # metal_ip          = equinix_metal_device.iibox.access_public_ipv4
  # iibox_agent_init  = coder_agent.iibox.init_script
  # iibox_agent_token = coder_agent.iibox.token
}
