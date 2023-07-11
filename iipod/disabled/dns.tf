resource "dns_a_record_set" "a_record" {
  count     = data.coder_parameter.dns.value ? data.coder_workspace.ii.start_count : 0
  zone      = "${var.coder_domain}."
  name      = "${local.spacename}.${local.namespace}"
  ttl       = 60
  addresses = [var.public_ip]
}

resource "coder_metadata" "a_record" {
  count       = data.coder_parameter.dns.value ? data.coder_workspace.ii.start_count : 0
  resource_id = dns_a_record_set.a_record[0].id
  hide        = true
  item {
    key   = "name"
    value = dns_a_record_set.a_record[0].name
  }
  item {
    key   = "zone"
    value = dns_a_record_set.a_record[0].zone
  }
  item {
    key   = "A"
    value = var.public_ip
    # value = dns_a_record_set.a_record[0].addresses
  }
}

resource "dns_a_record_set" "wild_a_record" {
  count     = data.coder_parameter.dns.value ? data.coder_workspace.ii.start_count : 0
  zone      = "${var.coder_domain}."
  name      = "*.${local.spacename}.${local.namespace}"
  ttl       = 60
  addresses = [var.public_ip]
}

resource "coder_metadata" "wild_a_record" {
  count       = data.coder_parameter.dns.value ? data.coder_workspace.ii.start_count : 0
  resource_id = dns_a_record_set.wild_a_record[0].id
  hide        = true
  item {
    key   = "name"
    value = dns_a_record_set.wild_a_record[0].name
  }
  item {
    key   = "zone"
    value = dns_a_record_set.wild_a_record[0].zone
  }
  item {
    key   = "A"
    value = var.public_ip
    # value = dns_a_record_set.wild_a_record[0].addresses
  }
}

resource "dns_a_record_set" "vnc_a_record" {
  count     = data.coder_parameter.dns.value ? data.coder_workspace.ii.start_count : 0
  zone      = "${var.coder_domain}."
  name      = "vnc-${local.spacename}.${local.namespace}"
  ttl       = 60
  addresses = [var.public_ip]
}

resource "coder_metadata" "vnc_a_record" {
  count       = data.coder_parameter.dns.value ? data.coder_workspace.ii.start_count : 0
  resource_id = dns_a_record_set.vnc_a_record[0].id
  hide        = true
  item {
    key   = "name"
    value = dns_a_record_set.vnc_a_record[0].name
  }
  item {
    key   = "zone"
    value = dns_a_record_set.vnc_a_record[0].zone
  }
  item {
    key   = "A"
    value = var.public_ip
    # value = dns_a_record_set.vnc_a_record[0].addresses
  }
}
resource "dns_a_record_set" "tmux_a_record" {
  count     = data.coder_parameter.dns.value ? data.coder_workspace.ii.start_count : 0
  zone      = "${var.coder_domain}."
  name      = "tmux-${local.spacename}.${local.namespace}"
  ttl       = 60
  addresses = [var.public_ip]
}
resource "coder_metadata" "tmux_a_record" {
  count       = data.coder_parameter.dns.value ? data.coder_workspace.ii.start_count : 0
  resource_id = dns_a_record_set.tmux_a_record[0].id
  hide        = true
  item {
    key   = "name"
    value = dns_a_record_set.tmux_a_record[0].name
  }
  item {
    key   = "zone"
    value = dns_a_record_set.tmux_a_record[0].zone
  }
  item {
    key   = "A"
    value = var.public_ip
    # value = dns_a_record_set.tmux_a_record[0].addresses
  }
}

resource "dns_a_record_set" "emacs_a_record" {
  count     = data.coder_parameter.dns.value ? data.coder_workspace.ii.start_count : 0
  zone      = "${var.coder_domain}."
  name      = "emacs-${local.spacename}.${local.namespace}"
  ttl       = 60
  addresses = [var.public_ip]
}
resource "coder_metadata" "emacs_a_record" {
  count       = data.coder_parameter.dns.value ? data.coder_workspace.ii.start_count : 0
  resource_id = dns_a_record_set.emacs_a_record[0].id
  hide        = true
  item {
    key   = "name"
    value = dns_a_record_set.emacs_a_record[0].name
  }
  item {
    key   = "zone"
    value = dns_a_record_set.emacs_a_record[0].zone
  }
  item {
    key   = "A"
    value = var.public_ip
    # value = dns_a_record_set.emacs_a_record[0].addresses
  }
}

resource "dns_a_record_set" "www_a_record" {
  count     = data.coder_parameter.dns.value ? data.coder_workspace.ii.start_count : 0
  zone      = "${var.coder_domain}."
  name      = "www-${local.spacename}.${local.namespace}"
  ttl       = 60
  addresses = [var.public_ip]
}
resource "coder_metadata" "www_a_record" {
  count       = data.coder_parameter.dns.value ? data.coder_workspace.ii.start_count : 0
  resource_id = dns_a_record_set.www_a_record[0].id
  hide        = true
  item {
    key   = "name"
    value = dns_a_record_set.www_a_record[0].name
  }
  item {
    key   = "zone"
    value = dns_a_record_set.www_a_record[0].zone
  }
  item {
    key   = "A"
    value = var.public_ip
    # value = dns_a_record_set.www_a_record[0].addresses
  }
}
