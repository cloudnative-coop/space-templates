# Currently only configurable within the coder instance / provisioner
# cloudnative.coop project under CNCF Account
# https://console.equinix.com/projects/f4a7273d-b1fc-4c50-93e8-7fed753c86ff
variable "project" {
  type        = string
  description = "Project from https://deploy.equinix.com/developers/docs/metal/accounts/projects/"
  default     = "f4a7273d-b1fc-4c50-93e8-7fed753c86ff" # pair.sharing.io
}
variable "domain" {
  type        = string
  description = "Power DNS Domain to create iiboxes in"
  default     = "sharing.io" # pair.sharing.io
}

locals {
  dns_zone          = "${lower(data.coder_workspace.ii.name)}-${lower(data.coder_workspace.ii.owner)}.${var.domain}"
  dns_fqdn          = "${local.dns_zone}." #adds a "." to the end
  iibox_agent_init  = coder_agent.iibox.init_script
  iibox_agent_token = coder_agent.iibox.token
  iipod_agent_init  = coder_agent.iipod.init_script
  iipod_agent_token = coder_agent.iipod.token
}
