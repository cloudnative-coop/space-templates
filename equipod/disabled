resource "kubernetes_namespace" "space" {
  metadata {
    annotations = {
      name = "annotate/space"
    }

    labels = {
      mylabel = "space-label"
    }

    name = local.spacename
  }
}

resource "kubernetes_role" "space-admin" {
  metadata {
    name      = "admin"
    namespace = local.spacename
    labels = {
      test = "MyRole"
    }
  }
  rule {
    api_groups = [""]
    resources  = ["*"]
    verbs      = ["*"]
  }
  rule {
    api_groups = ["*"]
    resources  = ["*"]
    verbs      = ["*"]
  }
}

resource "kubernetes_service_account" "space-admin" {
  metadata {
    name      = "admin"
    namespace = local.spacename
    labels = {
      test = "MyRole"
    }
  }
}
resource "kubernetes_role_binding" "space-admin" {
  metadata {
    name      = "admin"
    namespace = local.spacename
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = "admin"
    # name      = kubernetes_role.space-admin.name
  }
  subject {
    kind = "ServiceAccount"
    # name      = kubernetes_service_account.space-admin.name
    name      = "admin"
    namespace = local.spacename
  }
}
