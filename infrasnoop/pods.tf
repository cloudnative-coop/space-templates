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
      image   = data.coder_parameter.space-image.value
      command = ["sh", "-c", coder_agent.ii.init_script]
      security_context {
        run_as_user = "1001"
      }
      env {
        name  = "CODER_AGENT_TOKEN"
        value = coder_agent.ii.token
      }
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
      image   = data.coder_parameter.infrasnoop-image.value
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
      # readiness_probe {
      #   exec {
      #     command = "sh -c 'pg_isready -U ${POSTGRES_USER} -d ${POSTGRES_DB}'"
      #   }
      #   initial_delay_seconds = 5
      #   period_seconds = 5
      # }
      # liveness_probe {
      #   exec {
      #     command = "sh -c 'pg_isready -U ${POSTGRES_USER} -d ${POSTGRES_DB}'"
      #   }
      #   initial_delay_seconds = 5
      #   period_seconds = 5
      # }
      # env {
      #   name  = "CODER_AGENT_TOKEN"
      #   value = coder_agent.infrasnoop.token
      # }
      # From https://www.postgresql.org/docs/current/auth-trust.html
      # trust authentication is appropriate and very convenient for local connections on a single-user workstation.
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

      env {
        name  = "PGHOST"
        value = "localhost"
      }
      env {
        name  = "PGUSER"
        value = "postgres"
      }
      env {
        name  = "DATABASE_URL"
        value = "postgres://$POSTGRES_USER:$POSTGRES_PASSWORD@localhost:5432/$POSTGRES_DB"
      }
    }
    container {
      name    = "sideloader"
      image   = data.coder_parameter.sideloader-image.value
      security_context {
        run_as_user = "0"
      }

      # PG* vars are for configuring libpq based apps like psql
      # https://www.postgresql.org/docs/current/libpq-envars.html
      # I'm not sure if they are picked up by sideloader
      env {
        name  = "PGHOST"
        value = "localhost"
      }
      env {
        name  = "PGUSER"
        value = "postgres"
      }
      env {
        name  = "PGDATABASE"
        value = "postgres"
      }
      # If this container comes up before the database... we get this error on stdout:
      # Database is uninitialized and superuser password is not specified.
      # You must specify POSTGRES_PASSWORD to a non-empty value for the
      # superuser. For example, "-e POSTGRES_PASSWORD=password" on "docker run".
      env {
        name  = "POSTGRES_USER"
        value = "postgres"
      }
      # These errors seem to be coming from this pod
      env {
        name  = "POSTGRES_PASSWORD"
        value = "infra"
      }
      env {
        name  = "POSTGRES_HOST_AUTH_METHOD"
        value = "trust"
      }
      # Apparently this is the only variable that is picked up by sideloader
      env {
        name  = "DATABASE_URL"
        value = "postgres://postgres@localhost:5432/postgres"
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
