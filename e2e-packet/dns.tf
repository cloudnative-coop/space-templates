locals {
  dns_zone   = "${lower(data.coder_workspace.ii.name)}-${lower(data.coder_workspace.ii.owner)}.ii.nz"
  dns_fqdn   = "${local.dns_zone}." #adds a "." to the end
  elastic_ip = cidrhost(equinix_metal_reserved_ip_block.public_network.cidr_notation, 0)
}
resource "powerdns_record" "a_record" {
  name    = local.dns_fqdn
  records = [local.elastic_ip]
  zone    = "ii.nz."
  type    = "A"
  ttl     = 60
}

resource "powerdns_record" "wild_a_record" {
  name    = "*.${local.dns_fqdn}"
  records = [local.elastic_ip]
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
}

resource "acme_registration" "email" {
  account_key_pem = tls_private_key.secret.private_key_pem
  email_address   = "cert@ii.coop"
}

resource "acme_certificate" "wildcard" {
  account_key_pem           = acme_registration.email.account_key_pem
  common_name               = "*.${local.dns_zone}"
  subject_alternative_names = [local.dns_zone]
  # https://registry.terraform.io/providers/vancluever/acme/latest/docs/guides/dns-providers-pdns#argument-reference
  dns_challenge {
    provider = "pdns"
  }
  depends_on = [
    powerdns_record.wild_a_record
  ]
}
