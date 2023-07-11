resource "kubernetes_ingress_v1" "emacs" {
  count      = data.coder_parameter.dns.value ? data.coder_workspace.ii.start_count : 0
  depends_on = [null_resource.namespace]
  metadata {
    name      = "emacs-${local.spacename}"
    namespace = local.namespace
    labels = {
      "spacename" : local.spacename
    }
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
        "emacs-${local.space_domain}"
      ]
      secret_name = "wildcard-tls"
    }
    tls {
      hosts = [
        "emacs.${local.space_domain}"
      ]
      secret_name = "${local.spacename}-wildcard-tls"
    }
    rule {
      host = "emacs-${local.space_domain}"
      http {
        path {
          path      = "/"
          path_type = "ImplementationSpecific"
          backend {
            service {
              name = "emacs-${local.spacename}"
              port {
                # name   = "emacs"
                number = 80
              }
            }
          }
        }
      }
    }
    rule {
      host = "emacs.${local.space_domain}"
      http {
        path {
          path      = "/"
          path_type = "ImplementationSpecific"
          backend {
            service {
              name = "emacs-${local.spacename}"
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

resource "coder_metadata" "emacs-ingress" {
  count       = data.coder_parameter.dns.value ? data.coder_workspace.ii.start_count : 0
  resource_id = kubernetes_ingress_v1.emacs[0].id
  hide        = true
  item {
    key   = "name"
    value = kubernetes_ingress_v1.emacs[0].metadata[0].name
  }
  item {
    key   = "faster"
    value = "https://${kubernetes_ingress_v1.emacs[0].spec[0].rule[0].host}"
  }
  item {
    key   = "funner"
    value = "https://${kubernetes_ingress_v1.emacs[0].spec[0].rule[1].host}"
  }
}

resource "kubernetes_ingress_v1" "tmux" {
  count      = data.coder_parameter.dns.value ? data.coder_workspace.ii.start_count : 0
  depends_on = [null_resource.namespace]
  metadata {
    name      = "tmux-${local.spacename}"
    namespace = local.namespace
    labels = {
      "spacename" : local.spacename
    }
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
        "tmux-${local.space_domain}"
      ]
      secret_name = "wildcard-tls"
    }
    tls {
      hosts = [
        "tmux.${local.space_domain}"
      ]
      secret_name = "${local.spacename}-wildcard-tls"
    }
    rule {
      host = "tmux-${local.space_domain}"
      http {
        path {
          path      = "/"
          path_type = "ImplementationSpecific"
          backend {
            service {
              name = "ttyd-${local.spacename}"
              port {
                # name   = "ttyd"
                number = 80
              }
            }
          }
        }
      }
    }
    rule {
      host = "tmux.${local.space_domain}"
      http {
        path {
          path      = "/"
          path_type = "ImplementationSpecific"
          backend {
            service {
              name = "ttyd-${local.spacename}"
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

resource "coder_metadata" "tmux-ingress" {
  count       = data.coder_parameter.dns.value ? data.coder_workspace.ii.start_count : 0
  resource_id = kubernetes_ingress_v1.tmux[0].id
  hide        = true
  item {
    key   = "name"
    value = kubernetes_ingress_v1.tmux[0].metadata[0].name
  }
  item {
    key   = "faster"
    value = "https://${kubernetes_ingress_v1.tmux[0].spec[0].rule[0].host}"
  }
  item {
    key   = "funner"
    value = "https://${kubernetes_ingress_v1.tmux[0].spec[0].rule[1].host}"
  }
}

resource "kubernetes_ingress_v1" "vnc" {
  count      = data.coder_parameter.dns.value ? data.coder_workspace.ii.start_count : 0
  depends_on = [null_resource.namespace]
  metadata {
    name      = "vnc-${local.spacename}"
    namespace = local.namespace
    labels = {
      "spacename" : local.spacename
    }
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
        "vnc-${local.space_domain}"
      ]
      secret_name = "wildcard-tls"
    }
    tls {
      hosts = [
        "vnc.${local.space_domain}"
      ]
      secret_name = "${local.spacename}-wildcard-tls"
    }
    rule {
      host = "vnc-${local.space_domain}"
      http {
        path {
          path      = "/"
          path_type = "ImplementationSpecific"
          backend {
            service {
              name = "novnc-${local.spacename}"
              port {
                # name   = "ttyd"
                number = 80
              }
            }
          }
        }
      }
    }
    rule {
      host = "vnc.${local.space_domain}"
      http {
        path {
          path      = "/"
          path_type = "ImplementationSpecific"
          backend {
            service {
              name = "novnc-${local.spacename}"
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

resource "coder_metadata" "vnc-ingress" {
  count       = data.coder_parameter.dns.value ? data.coder_workspace.ii.start_count : 0
  resource_id = kubernetes_ingress_v1.vnc[0].id
  hide        = true
  item {
    key   = "name"
    value = kubernetes_ingress_v1.vnc[0].metadata[0].name
  }
  item {
    key   = "faster"
    value = "https://${kubernetes_ingress_v1.vnc[0].spec[0].rule[0].host}"
  }
  item {
    key   = "funner"
    value = "https://${kubernetes_ingress_v1.vnc[0].spec[0].rule[1].host}"
  }
}

resource "kubernetes_ingress_v1" "www" {
  count      = data.coder_parameter.dns.value ? data.coder_workspace.ii.start_count : 0
  depends_on = [null_resource.namespace]
  metadata {
    name      = "www-${local.spacename}"
    namespace = local.namespace
    labels = {
      "spacename" : local.spacename
    }
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
        "www-${local.space_domain}"
      ]
      secret_name = "wildcard-tls"
    }
    tls {
      hosts = [
        "www.${local.space_domain}"
      ]
      secret_name = "${local.spacename}-wildcard-tls"
    }
    rule {
      host = "www-${local.space_domain}"
      http {
        path {
          path      = "/"
          path_type = "ImplementationSpecific"
          backend {
            service {
              name = "www-${local.spacename}"
              port {
                # name   = "ttyd"
                number = 80
              }
            }
          }
        }
      }
    }
    rule {
      host = "www.${local.space_domain}"
      http {
        path {
          path      = "/"
          path_type = "ImplementationSpecific"
          backend {
            service {
              name = "www-${local.spacename}"
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

resource "coder_metadata" "www-ingress" {
  count       = data.coder_parameter.dns.value ? data.coder_workspace.ii.start_count : 0
  resource_id = kubernetes_ingress_v1.www[0].id
  hide        = true
  item {
    key   = "name"
    value = kubernetes_ingress_v1.www[0].metadata[0].name
  }
  item {
    key   = "faster"
    value = "https://${kubernetes_ingress_v1.www[0].spec[0].rule[0].host}"
  }
  item {
    key   = "funner"
    value = "https://${kubernetes_ingress_v1.www[0].spec[0].rule[1].host}"
  }
}
