locals {
  dns_zone   = "${lower(data.coder_workspace.ii.name)}-${lower(data.coder_workspace.ii.owner)}.ii.nz"
}
resource "powerdns_record" "a_record" {
  name    = "${lower(data.coder_workspace.ii.owner)}-${lower(data.coder_workspace.ii.name)}.ii.nz."
  records = [cidrhost(equinix_metal_reserved_ip_block.public_network.cidr_notation, 0)]
  zone    = "ii.nz."
  type    = "A"
  ttl     = 60
}

resource "powerdns_record" "wild_a_record" {
  name    = "*.${lower(data.coder_workspace.ii.owner)}-${lower(data.coder_workspace.ii.name)}.ii.nz."
  records = [cidrhost(equinix_metal_reserved_ip_block.public_network.cidr_notation, 0)]
  zone    = "ii.nz."
  type    = "A"
  ttl     = 60
  depends_on = [
    powerdns_record.a_record
  ]
}

resource "tls_private_key" "secret" {
  algorithm = "RSA"
  # rsa_bits  = 4096
  # Other options
  # algorithm   = "ECDSA"
  # ecdsa_curve = "P224"
  # algorithm   = "ED25519"
}

resource "acme_registration" "reg" {
  account_key_pem = tls_private_key.secret.private_key_pem
  email_address   = "cert@ii.coop"
}

resource "acme_certificate" "certificate" {
  account_key_pem           = acme_registration.reg.account_key_pem
  common_name               = "*.${lower(data.coder_workspace.ii.owner)}-${lower(data.coder_workspace.ii.name)}.ii.nz"
  subject_alternative_names = ["${lower(data.coder_workspace.ii.owner)}-${lower(data.coder_workspace.ii.name)}.ii.nz"]
  # https://registry.terraform.io/providers/vancluever/acme/latest/docs/guides/dns-providers-pdns#argument-reference
  dns_challenge {
    provider = "pdns"
  }
  depends_on = [
    powerdns_record.wild_a_record
  ]
}
