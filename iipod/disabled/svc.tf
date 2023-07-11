resource "kubernetes_service" "www" {
  count = data.coder_parameter.dns.value ? data.coder_workspace.ii.start_count : 0
  metadata {
    name      = "www-${local.spacename}"
    namespace = local.namespace
    labels = {
      "spacename" : local.spacename
    }
  }
  spec {
    selector = {
      "spacename" : data.coder_workspace.ii.name
    }
    port {
      port        = 80
      protocol    = "TCP"
      target_port = 80
    }
  }
  depends_on = [null_resource.namespace]
}

resource "coder_metadata" "www" {
  count       = data.coder_parameter.dns.value ? data.coder_workspace.ii.start_count : 0
  resource_id = kubernetes_service.www[0].id
  hide        = true
  item {
    key   = "name"
    value = kubernetes_service.www[0].metadata[0].name
  }
  item {
    key   = "selector"
    value = "spacename: ${kubernetes_service.www[0].spec[0].selector.spacename}"
  }
  item {
    key   = "port"
    value = kubernetes_service.www[0].spec[0].port[0].port
  }
  item {
    key   = "target_port"
    value = kubernetes_service.www[0].spec[0].port[0].target_port
  }
}

resource "kubernetes_service" "emacs" {
  count = data.coder_parameter.dns.value ? data.coder_workspace.ii.start_count : 0
  metadata {
    name      = "emacs-${local.spacename}"
    namespace = local.namespace
    labels = {
      "spacename" : local.spacename
    }
  }
  spec {
    selector = {
      "spacename" : data.coder_workspace.ii.name
    }
    port {
      port        = 80
      protocol    = "TCP"
      target_port = 8085
    }
  }
  depends_on = [null_resource.namespace]
}

resource "coder_metadata" "emacs" {
  count       = data.coder_parameter.dns.value ? data.coder_workspace.ii.start_count : 0
  resource_id = kubernetes_service.emacs[0].id
  hide        = true
  item {
    key   = "name"
    value = kubernetes_service.emacs[0].metadata[0].name
  }
  item {
    key   = "selector"
    value = "spacename: ${kubernetes_service.emacs[0].spec[0].selector.spacename}"
  }
  item {
    key   = "port"
    value = kubernetes_service.emacs[0].spec[0].port[0].port
  }
  item {
    key   = "target_port"
    value = kubernetes_service.emacs[0].spec[0].port[0].target_port
  }
}

resource "kubernetes_service" "ttyd" {
  count = data.coder_parameter.dns.value ? data.coder_workspace.ii.start_count : 0
  metadata {
    name      = "ttyd-${local.spacename}"
    namespace = local.namespace
    labels = {
      "spacename" : local.spacename
    }
  }
  spec {
    selector = {
      "spacename" = data.coder_workspace.ii.name
      # app = local.spacename
    }
    port {
      port        = 80
      protocol    = "TCP"
      target_port = 7681
    }
  }
  depends_on = [null_resource.namespace]
}

resource "coder_metadata" "ttyd" {
  count       = data.coder_parameter.dns.value ? data.coder_workspace.ii.start_count : 0
  resource_id = kubernetes_service.ttyd[0].id
  hide        = true
  item {
    key   = "name"
    value = kubernetes_service.ttyd[0].metadata[0].name
  }
  item {
    key   = "selector"
    value = "spacename: ${kubernetes_service.ttyd[0].spec[0].selector.spacename}"
  }
  item {
    key   = "port"
    value = kubernetes_service.ttyd[0].spec[0].port[0].port
  }
  item {
    key   = "target_port"
    value = kubernetes_service.ttyd[0].spec[0].port[0].target_port
  }
}

resource "kubernetes_service" "novnc" {
  count = data.coder_parameter.dns.value ? data.coder_workspace.ii.start_count : 0
  metadata {
    name      = "novnc-${local.spacename}"
    namespace = local.namespace
    labels = {
      "spacename" : local.spacename
    }
  }
  spec {
    selector = {
      "spacename" = data.coder_workspace.ii.name
      # app = local.spacename
    }
    port {
      port        = 80
      protocol    = "TCP"
      target_port = 6080
    }
  }
  depends_on = [null_resource.namespace]
}

resource "coder_metadata" "novnc" {
  count       = data.coder_parameter.dns.value ? data.coder_workspace.ii.start_count : 0
  resource_id = kubernetes_service.novnc[0].id
  hide        = true
  item {
    key   = "name"
    value = kubernetes_service.novnc[0].metadata[0].name
  }
  item {
    key   = "selector"
    value = "spacename: ${kubernetes_service.novnc[0].spec[0].selector.spacename}"
  }
  item {
    key   = "port"
    value = kubernetes_service.novnc[0].spec[0].port[0].port
  }
  item {
    key   = "target_port"
    value = kubernetes_service.novnc[0].spec[0].port[0].target_port
  }
}
