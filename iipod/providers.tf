terraform {
  required_providers {
    coder = {
      source  = "coder/coder"
      version = "0.8.3" # Current as of June 11th 2023
    }
    equinix = {
      source  = "equinix/equinix"
      version = "1.14.3" # Current as of June 11th 2023
    }
    github = {
      source  = "integrations/github"
      version = "5.26.0" # Current as of June 11th 2023
    }
    acme = {
      source  = "vancluever/acme"
      version = "2.14.0" # Current as of June 8th 2023
    }
    tls = {
      source  = "hashicorp/tls"
      version = "4.0.4" # Current as of June 8th 2023
    }
    # powerdns = {
    #   source  = "pan-net/powerdns"
    #   version = "1.5.0" # Current as of June 8th 2023
    # }
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.1"
    }
  }
}

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
  # server_url = "https://acme-staging-v02.api.letsencrypt.org/directory"
  server_url = "https://acme-v02.api.letsencrypt.org/directory"
}
# provider "powerdns" {
#   # https://registry.terraform.io/providers/pan-net/powerdns/latest/docs
#   # https://doc.powerdns.com/authoritative/backends/generic-postgresql.html
#   # https://registry.terraform.io/providers/pan-net/powerdns/latest/docs#argument-reference
#   # PDNS_API_KEY = (copied secret over from powerdns admin)
#   # PDNS_SERVER_URL = https://pdns.ii.nz
#   # TODO: LUA Records? https://github.com/dmachard/terraform-provider-powerdns-gslb
#   # https://registry.terraform.io/providers/pan-net/powerdns/latest/docs/resources/record
# }
