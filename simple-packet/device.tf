# TODO: use https://registry.terraform.io/providers/hashicorp/cloudinit/latest/docs
resource "equinix_metal_device" "amd_machine" {
  project_id       = var.project
  hostname         = "${lower(data.coder_workspace.ii.owner)}-${lower(data.coder_workspace.ii.name)}"
  metro            = data.coder_parameter.metro.value
  plan             = data.coder_parameter.plan.value
  operating_system = data.coder_parameter.os.value
  user_data = templatefile("cloud-config.yaml.tftpl", {
    username = "ii"
    # username          = data.coder_workspace.ii.owner
    coder_agent_token = coder_agent.ii.token
    init_script       = base64encode(coder_agent.ii.init_script)
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
