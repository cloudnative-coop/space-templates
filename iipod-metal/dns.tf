resource "coder_metadata" "a_record" {
  resource_id = powerdns_record.a_record.id
  count       = data.coder_workspace.ii.start_count
  hide        = true
  # item {
  #   key   = "domain"
  #   value = "${powerdns_record.a_record.name}.${powerdns_record.a_record.zone}"
  # }
  # item {
  #   key   = "A"
  #   value = equinix_metal_device.iibox.access_public_ipv4
  # }
}

resource "coder_metadata" "wild_a_record" {
  resource_id = powerdns_record.wild_a_record.id
  count       = data.coder_workspace.ii.start_count
  icon        = "/icon/node.svg"
  hide        = true
  # item {
  #   key   = "wildcard"
  #   value = powerdns_record.wild_a_record.name
  #   # ".${powerdns_record.wild_a_record.zone}"
  # }
  # item {
  #   key   = "A"
  #   value = equinix_metal_device.iibox.access_public_ipv4
  # }
}

resource "powerdns_record" "a_record" {
  name    = local.dns_fqdn
  zone    = "ii.nz."
  type    = "A"
  ttl     = 60
  records = [equinix_metal_device.iibox.access_public_ipv4]
  # records = [local.elastic_ip]
}

resource "powerdns_record" "wild_a_record" {
  name = "*.${local.dns_fqdn}"
  zone = "ii.nz."
  type = "A"
  ttl  = 60
  # depends_on = [
  #   powerdns_record.a_record
  # ]
  records = [equinix_metal_device.iibox.access_public_ipv4]
  # records = [local.elastic_ip]
}

