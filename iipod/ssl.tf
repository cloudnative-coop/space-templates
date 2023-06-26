resource "coder_metadata" "key" {
  resource_id = tls_private_key.secret[0].id
  count       = data.coder_parameter.dns.value ? data.coder_workspace.ii.start_count : 0
  hide        = true
  item {
    key   = "algorithm"
    value = tls_private_key.secret[0].algorithm
  }
  item {
    key   = "rsa_bits"
    value = tls_private_key.secret[0].rsa_bits
  }
  # Maybe some logic to display ecdsa_curve based on algorithm?
  # item {
  #   key   = "ecdsa_curve"
  #   value = tls_private_key.secret.ecdsa_curve
  # }
}

resource "coder_metadata" "registration" {
  resource_id = acme_registration.email[0].id
  count       = data.coder_parameter.dns.value ? data.coder_workspace.ii.start_count : 0
  hide        = true
  item {
    key   = "email"
    value = acme_registration.email[0].email_address
  }
  item {
    key   = "registration_url"
    value = acme_registration.email[0].registration_url
  }
}

resource "coder_metadata" "certificate" {
  resource_id = acme_certificate.wildcard[0].id
  count       = data.coder_parameter.dns.value ? data.coder_workspace.ii.start_count : 0
  icon        = "https://raw.githubusercontent.com/cert-manager/cert-manager/master/logo/logo.svg"
  # hide        = true
  # item {
  #   key   = "emacs"
  #   value = "http://emacs.${local.dns_zone}"
  # }
  # item {
  #   key   = "vnc"
  #   value = "http://novnc.${local.dns_zone}"
  # }
  # item {
  #   key   = "ttyd"
  #   value = "http://ttyd.${local.dns_zone}"
  # }
  # item {
  #   key   = "hubble"
  #   value = "http://hubble.${local.dns_zone}"
  # }
  item {
    key   = "domain"
    value = acme_certificate.wildcard[0].certificate_domain
  }
  item {
    key   = "cert_url"
    value = acme_certificate.wildcard[0].certificate_url
  }
  item {
    key   = "expires"
    value = acme_certificate.wildcard[0].certificate_not_after
  }
}

resource "tls_private_key" "secret" {
  count     = data.coder_parameter.dns.value ? data.coder_workspace.ii.start_count : 0
  algorithm = "RSA"
  # rsa_bits  = 4096
}

resource "acme_registration" "email" {
  count           = data.coder_parameter.dns.value ? data.coder_workspace.ii.start_count : 0
  account_key_pem = tls_private_key.secret[0].private_key_pem
  email_address   = "cert@ii.coop"
}

resource "acme_certificate" "wildcard" {
  count                     = data.coder_parameter.dns.value ? data.coder_workspace.ii.start_count : 0
  account_key_pem           = acme_registration.email[0].account_key_pem
  common_name               = "*.${local.dns_zone}"
  subject_alternative_names = [local.dns_zone]
  # https://registry.terraform.io/providers/vancluever/acme/latest/docs/guides/dns-providers-pdns#argument-reference
  dns_challenge {
    provider = "pdns"
  }
}

resource "kubernetes_secret" "wildcard-tls" {
  count      = data.coder_parameter.dns.value ? data.coder_workspace.ii.start_count : 0
  depends_on = [kubernetes_namespace.space]
  metadata {
    name      = "wildcard-tls"
    namespace = local.spacename
  }
  type = "kubernetes.io/tls"
  data = {
    "tls.crt" = "${acme_certificate.wildcard[0].certificate_pem}${acme_certificate.wildcard[0].issuer_pem}"
    "tls.key" = acme_certificate.wildcard[0].private_key_pem
  }
}

resource "kubernetes_service" "www" {
  count = data.coder_parameter.dns.value ? data.coder_workspace.ii.start_count : 0
  metadata {
    name      = "www"
    namespace = local.spacename
  }
  spec {
    selector = {
      "spacename" : data.coder_workspace.ii.name
      "spaceowner" : data.coder_workspace.ii.owner
    }
    port {
      port        = 80
      protocol    = "TCP"
      target_port = 80
    }
  }
  depends_on = [kubernetes_namespace.space]
}
resource "kubernetes_service" "emacs" {
  count = data.coder_parameter.dns.value ? data.coder_workspace.ii.start_count : 0
  metadata {
    name      = "emacs"
    namespace = local.spacename
  }
  spec {
    selector = {
      "spacename" : data.coder_workspace.ii.name
      "spaceowner" : data.coder_workspace.ii.owner
    }
    port {
      port        = 80
      protocol    = "TCP"
      target_port = 8085
    }
  }
  depends_on = [kubernetes_namespace.space]
}
resource "kubernetes_service" "ttyd" {
  count = data.coder_parameter.dns.value ? data.coder_workspace.ii.start_count : 0
  metadata {
    name      = "ttyd"
    namespace = local.spacename
  }
  spec {
    selector = {
      "spacename"  = data.coder_workspace.ii.name
      "spaceowner" = data.coder_workspace.ii.owner
      # app = local.spacename
    }
    port {
      port        = 80
      protocol    = "TCP"
      target_port = 7681
    }
  }
  depends_on = [kubernetes_namespace.space]
}

resource "kubernetes_service" "novnc" {
  count = data.coder_parameter.dns.value ? data.coder_workspace.ii.start_count : 0
  metadata {
    name      = "novnc"
    namespace = local.spacename
  }
  spec {
    selector = {
      "spacename"  = data.coder_workspace.ii.name
      "spaceowner" = data.coder_workspace.ii.owner
      # app = local.spacename
    }
    port {
      port        = 80
      protocol    = "TCP"
      target_port = 6080
    }
  }
  depends_on = [kubernetes_namespace.space]
}

resource "kubernetes_ingress_v1" "emacs" {
  count      = data.coder_parameter.dns.value ? data.coder_workspace.ii.start_count : 0
  depends_on = [kubernetes_namespace.space]
  metadata {
    name      = "emacs"
    namespace = local.spacename
    annotations = {
      "nginx.ingress.kubernetes.io/proxy-read-timeout" : "3600"
      "nginx.ingress.kubernetes.io/proxy-send-timeout" : "3600"
      "nginx.ingress.kubernetes.io/server-snippets" : <<EOF
location / {
proxy_set_header Upgrade $http_upgrade;
proxy_http_version 1.1;
proxy_set_header X-Forwarded-Host $http_host;
proxy_set_header X-Forwarded-Proto $scheme;
proxy_set_header X-Forwarded-For $remote_addr;
proxy_set_header Host $host;
proxy_set_header Connection "upgrade";
proxy_cache_bypass $http_upgrade;
}
EOF
    }
  }
  spec {
    ingress_class_name = "nginx"
    tls {
      hosts = [
        "emacs.${local.dns_zone}"
      ]
      secret_name = "wildcard-tls"
    }
    rule {
      host = "emacs.${local.dns_zone}"
      http {
        path {
          path      = "/"
          path_type = "ImplementationSpecific"
          backend {
            service {
              name = "emacs"
              port {
                # name   = "emacs"
                number = 80
              }
            }
          }
        }
      }
    }
  }
}
resource "kubernetes_ingress_v1" "tmux" {
  count      = data.coder_parameter.dns.value ? data.coder_workspace.ii.start_count : 0
  depends_on = [kubernetes_namespace.space]
  metadata {
    name      = "tmux"
    namespace = local.spacename
    annotations = {
      "nginx.ingress.kubernetes.io/proxy-read-timeout" : "3600"
      "nginx.ingress.kubernetes.io/proxy-send-timeout" : "3600"
      "nginx.ingress.kubernetes.io/server-snippets" : <<EOF
location / {
proxy_set_header Upgrade $http_upgrade;
proxy_http_version 1.1;
proxy_set_header X-Forwarded-Host $http_host;
proxy_set_header X-Forwarded-Proto $scheme;
proxy_set_header X-Forwarded-For $remote_addr;
proxy_set_header Host $host;
proxy_set_header Connection "upgrade";
proxy_cache_bypass $http_upgrade;
}
EOF
    }
  }
  spec {
    ingress_class_name = "nginx"
    tls {
      hosts = [
        "tmux.${local.dns_zone}"
      ]
      secret_name = "wildcard-tls"
    }
    rule {
      host = "tmux.${local.dns_zone}"
      http {
        path {
          path      = "/"
          path_type = "ImplementationSpecific"
          backend {
            service {
              name = "ttyd"
              port {
                # name   = "ttyd"
                number = 80
              }
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_ingress_v1" "vnc" {
  count      = data.coder_parameter.dns.value ? data.coder_workspace.ii.start_count : 0
  depends_on = [kubernetes_namespace.space]
  metadata {
    name      = "vnc"
    namespace = local.spacename
    annotations = {
      "nginx.ingress.kubernetes.io/proxy-read-timeout" : "3600"
      "nginx.ingress.kubernetes.io/proxy-send-timeout" : "3600"
      "nginx.ingress.kubernetes.io/server-snippets" : <<EOF
location / {
proxy_set_header Upgrade $http_upgrade;
proxy_http_version 1.1;
proxy_set_header X-Forwarded-Host $http_host;
proxy_set_header X-Forwarded-Proto $scheme;
proxy_set_header X-Forwarded-For $remote_addr;
proxy_set_header Host $host;
proxy_set_header Connection "upgrade";
proxy_cache_bypass $http_upgrade;
}
EOF
    }
  }
  spec {
    ingress_class_name = "nginx"
    tls {
      hosts = [
        "vnc.${local.dns_zone}"
      ]
      secret_name = "wildcard-tls"
    }
    rule {
      host = "vnc.${local.dns_zone}"
      http {
        path {
          path      = "/"
          path_type = "ImplementationSpecific"
          backend {
            service {
              name = "novnc"
              port {
                # name   = "ttyd"
                number = 80
              }
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_ingress_v1" "www" {
  count      = data.coder_parameter.dns.value ? data.coder_workspace.ii.start_count : 0
  depends_on = [kubernetes_namespace.space]
  metadata {
    name      = "www"
    namespace = local.spacename
    annotations = {
      "nginx.ingress.kubernetes.io/proxy-read-timeout" : "3600"
      "nginx.ingress.kubernetes.io/proxy-send-timeout" : "3600"
      "nginx.ingress.kubernetes.io/server-snippets" : <<EOF
location / {
proxy_set_header Upgrade $http_upgrade;
proxy_http_version 1.1;
proxy_set_header X-Forwarded-Host $http_host;
proxy_set_header X-Forwarded-Proto $scheme;
proxy_set_header X-Forwarded-For $remote_addr;
proxy_set_header Host $host;
proxy_set_header Connection "upgrade";
proxy_cache_bypass $http_upgrade;
}
EOF
    }
  }
  spec {
    ingress_class_name = "nginx"
    tls {
      hosts = [
        "www.${local.dns_zone}"
      ]
      secret_name = "wildcard-tls"
    }
    rule {
      host = "www.${local.dns_zone}"
      http {
        path {
          path      = "/"
          path_type = "ImplementationSpecific"
          backend {
            service {
              name = "www"
              port {
                # name   = "ttyd"
                number = 80
              }
            }
          }
        }
      }
    }
  }
}
