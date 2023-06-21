resource "coder_metadata" "a_record" {
  resource_id = powerdns_record.a_record.id
  count       = data.coder_workspace.ii.start_count
  hide        = true
  item {
    key   = "domain"
    value = "${powerdns_record.a_record.name}.${powerdns_record.a_record.zone}"
  }
  item {
    key   = "A"
    value = local.public_ip
  }
}

resource "coder_metadata" "wild_a_record" {
  resource_id = powerdns_record.wild_a_record.id
  count       = data.coder_workspace.ii.start_count
  icon        = "/icon/node.svg"
  hide        = true
  # Our ingress
  item {
    key   = "wildcard"
    value = powerdns_record.wild_a_record.name
    # ".${powerdns_record.wild_a_record.zone}"
  }
  item {
    key   = "A"
    value = local.public_ip
  }
}

resource "powerdns_record" "a_record" {
  name    = local.dns_fqdn
  zone    = "${var.domain}."
  type    = "A"
  ttl     = 60
  records = [local.public_ip]
  # records = [local.elastic_ip]
}

resource "powerdns_record" "wild_a_record" {
  name = "*.${local.dns_fqdn}"
  zone = "${var.domain}."
  type = "A"
  ttl  = 60
  # depends_on = [
  #   powerdns_record.a_record
  # ]
  records = [local.public_ip]
  # records = [local.elastic_ip]
}

