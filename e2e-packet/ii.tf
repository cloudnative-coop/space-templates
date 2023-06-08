terraform {
  required_providers {
    coder = {
      source  = "coder/coder"
      version = "0.7.0" # Current as of May 30th 2023
    }
    equinix = {
      source  = "equinix/equinix"
      version = "1.14.2" # Current as of May 30th 2023
    }
    github = {
      source  = "integrations/github"
      version = "5.25.1" # Current as of May 30th 2023
    }
    # https://registry.terraform.io/providers/pan-net/powerdns/latest/docs
    # TODO: Possibly migrate to postgresql
    # https://github.com/pan-net/terraform-provider-powerdns/issues/75
    # https://doc.powerdns.com/authoritative/backends/generic-postgresql.html
    # https://doc.powerdns.com/authoritative/migration.html#moving-from-source-to-target
    # TODO: Possibly configure parallelism=1
    # https://registry.terraform.io/providers/pan-net/powerdns/latest/docs#argument-reference
    # PDNS_API_KEY = (copied secret over from powerdns admin)
    # PDNS_SERVER_URL = https://pdns.ii.nz
    powerdns = {
      source  = "pan-net/powerdns"
      version = "1.5.0" # Current as of June 8th 2023
    }
    acme = {
      source  = "vancluever/acme"
      version = "2.14.0" # Current as of June 8th 2023
    }
    tls = {
      source  = "hashicorp/tls"
      version = "4.0.4" # Current as of June 8th 2023
    }
    # TODO: LUA Records? https://github.com/dmachard/terraform-provider-powerdns-gslb
    # https://registry.terraform.io/providers/pan-net/powerdns/latest/docs/resources/record
    #
    # This approach added complexity without certain value, but if others see something I don't, I'd like to know!
    # cloudinit = {
    #   source  = "hashicorp/cloudinit"
    #   version = "2.3.2" # Current as of June 18th 2023
    # }
  }
}

# variable "GITHUB_TOKEN" {
#   type = string
# }

provider "coder" {
  # Configuration options
  # https://registry.terraform.io/providers/coder/coder/latest/docs#schema
  feature_use_managed_variables = true
}
provider "equinix" {
  # Configuration options
  # https://registry.terraform.io/providers/equinix/equinix/latest/docs#argument-reference
}
provider "github" {
  # Configuration options
  # https://registry.terraform.io/providers/integrations/github/latest/docs#argument-reference
  # token = var.COOP_GITHUB_TOKEN
  owner = "cloudnative-coop"
}
provider "acme" {
  # https://registry.terraform.io/providers/vancluever/acme/latest/docs#argument-reference
  server_url = "https://acme-staging-v02.api.letsencrypt.org/directory"
}

data "coder_workspace" "ii" {}

# Currently only configurable within the coder intsance / provisioner
variable "project" {
  type        = string
  description = "Project from https://deploy.equinix.com/developers/docs/metal/accounts/projects/"
  default     = "f4a7273d-b1fc-4c50-93e8-7fed753c86ff" # pair.sharing.io
}

data "coder_parameter" "metro" {
  name         = "metro"
  display_name = "Metro"
  description  = "The Equinix Metal Metro for the machine"
  default      = "dc"
  icon         = "https://raw.githubusercontent.com/matifali/logos/main/docker.svg"
  option {
    name  = "Sydney, Australia"
    value = "sy"
    icon  = "https://upload.wikimedia.org/wikipedia/commons/thumb/a/a9/Flag_of_the_United_States_%28DoS_ECA_Color_Standard%29.svg/1200px-Flag_of_the_United_States_%28DoS_ECA_Color_Standard%29.svg.png"
  }
  option {
    name  = "Dallas, Texas, USA"
    value = "da"
    icon  = "https://upload.wikimedia.org/wikipedia/commons/thumb/f/f7/Flag_of_Texas.svg/1200px-Flag_of_Texas.svg.png"
  }
  option {
    name  = "Washington, DC, USA"
    value = "dc"
    icon  = "https://upload.wikimedia.org/wikipedia/commons/thumb/a/a9/Flag_of_the_United_States_%28DoS_ECA_Color_Standard%29.svg/1200px-Flag_of_the_United_States_%28DoS_ECA_Color_Standard%29.svg.png"
  }
  option {
    name  = "Silicon Valley, USA"
    value = "sv"
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
resource "coder_metadata" "ip_attachment" {
  resource_id = equinix_metal_ip_attachment.public_ip.id
  item {
    key   = "elastc ip"
    value = equinix_metal_ip_attachment.public_ip.address
  }
}
resource "coder_metadata" "device_info" {
  count       = data.coder_workspace.ii.transition == "start" ? 1 : 0
  resource_id = equinix_metal_device.machine.id
  item {
    key   = "direct ssh"
    value = "ssh root@${equinix_metal_device.machine.access_public_ipv4}"
  }
  item {
    key   = "serial console"
    value = "ssh ${equinix_metal_device.machine.id}@sos.${equinix_metal_device.machine.deployed_facility}.platformequinix.com"
  }
  item {
    key   = "equinix console"
    value = "https://console.equinix.com/devices/${equinix_metal_device.machine.id}/overview"
  }
}
