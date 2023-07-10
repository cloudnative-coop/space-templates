resource "coder_metadata" "a_record" {
  count       = data.coder_parameter.dns.value ? data.coder_workspace.ii.start_count : 0
  resource_id = powerdns_record.a_record[0].id
  hide        = true
  item {
    key   = "domain"
    value = "${powerdns_record.a_record[0].name}.${powerdns_record.a_record[0].zone}"
  }
  item {
    key   = "A"
    value = local.public_ip
  }
}

resource "coder_metadata" "wild_a_record" {
  resource_id = powerdns_record.wild_a_record[0].id
  count       = data.coder_parameter.dns.value ? data.coder_workspace.ii.start_count : 0
  icon        = "/icon/node.svg"
  hide        = true
  # Our ingress
  item {
    key   = "wildcard"
    value = powerdns_record.wild_a_record[0].name
    # ".${powerdns_record.wild_a_record.zone}"
  }
  item {
    key   = "A"
    value = local.public_ip
  }
}

resource "powerdns_record" "a_record" {
  count   = data.coder_parameter.dns.value ? data.coder_workspace.ii.start_count : 0
  name    = local.dns_fqdn
  zone    = "${data.coder_parameter.domain.value}."
  type    = "A"
  ttl     = 60
  records = [local.public_ip]
  # records = [local.elastic_ip]
}

resource "powerdns_record" "wild_a_record" {
  count = data.coder_parameter.dns.value ? data.coder_workspace.ii.start_count : 0
  name  = "*.${local.dns_fqdn}"
  zone  = "${data.coder_parameter.domain.value}."
  type  = "A"
  ttl   = 60
  # depends_on = [
  #   powerdns_record.a_record
  # ]
  records = [local.public_ip]
  # records = [local.elastic_ip]
}
