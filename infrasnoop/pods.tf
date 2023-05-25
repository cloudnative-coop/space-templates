# From https://kubernetes.io/docs/concepts/workloads/pods/#pod-networking
# Inside a Pod (and only then),
# the containers that belong to the Pod can communicate with one another using localhost.
resource "kubernetes_pod" "iipod" {
  count = data.coder_workspace.ii.transition == "start" ? 1 : 0
  metadata {
    name      = "${lower(data.coder_workspace.ii.owner)}-${lower(data.coder_workspace.ii.name)}"
    namespace = "coder"
  }
  spec {
    security_context {
      run_as_user = "1001"
      fs_group    = "1001"
    }
    container {
      name    = "iipod"
      image   = data.coder_parameter.space_image.value
      command = ["sh", "-c", coder_agent.ii.init_script]
      security_context {
        run_as_user = "1001"
      }
      env {
        name  = "CODER_AGENT_TOKEN"
        value = coder_agent.ii.token
      }
      # env {
      #   name  = "GITHUB_TOKEN"
      #   value = data.coder_git_auth.github.access_token
      # }
      env {
        name  = "PGHOST"
        value = "localhost"
      }
      env {
        name  = "PGUSER"
        value = "postgres"
      }
    }
    container {
      name    = "infrasnoop"
      image   = data.coder_parameter.infrasnoop_image.value
      volume_mount {
        mount_path = "/data"
        name = "data"
      }
      # command = ["sh", "-c", coder_agent.infrasnoop.init_script]
      security_context {
        run_as_user = "0"
      }
      startup_probe {
        exec {
          command = ["sh", "-c", "pg_isready -U postgres -d postgres"]
        }
        initial_delay_seconds = 5
        failure_threshold= 5
        period_seconds = 5
      }
      # env {
      #   name  = "CODER_AGENT_TOKEN"
      #   value = coder_agent.ii.token
      # }
      env {
        name  = "POSTGRES_HOST_AUTH_METHOD"
        value = "trust"
      }
      env {
        name  = "POSTGRES_USER"
        value = "postgres"
      }
      env {
        name  = "POSTGRES_PASSWORD"
        value = "infra"
      }
      # From https://www.postgresql.org/docs/current/auth-trust.html
      # trust authentication is appropriate and very convenient for local connections on a single-user workstation.
      env {
        name  = "PGHOST"
        value = "localhost"
      }
      env {
        name  = "PGUSER"
        value = "postgres"
      }
    }
    container {
      name    = "sideloader"
      image   = data.coder_parameter.sideloader_image.value
      security_context {
        run_as_user = "0"
      }

      # PG* vars are for configuring libpq based apps like psql
      # https://www.postgresql.org/docs/current/libpq-envars.html
      # env {
      #   name  = "PGHOST"
      #   value = "localhost"
      # }
      # env {
      #   name  = "PGUSER"
      #   value = "postgres"
      # }
      # env {
      #   name  = "PGDATABASE"
      #   value = "postgres"
      # }
      env {
        name  = "DATABASE_URL"
        value = "postgres://postgres:infra@localhost:5432/postgres"
      }
    }

    # warning this is only around for the duration of the pod
    # space upgrades will kill it
    volume {
      name = "data"
      empty_dir {
        size_limit = "5000Mi"
      }
    }
  }
}
