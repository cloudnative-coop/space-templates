locals {
  dns_zone          = "${lower(data.coder_workspace.ii.name)}-${lower(data.coder_workspace.ii.owner)}.ii.nz"
  dns_fqdn          = "${local.dns_zone}." #adds a "." to the end
  iibox_agent_init  = coder_agent.iibox.init_script
  iibox_agent_token = coder_agent.iibox.token
  iipod_agent_init  = coder_agent.iipod.init_script
  iipod_agent_token = coder_agent.iipod.token
}
