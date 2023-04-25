terraform {
  required_providers {
    coder = {
      source  = "coder/coder"
      version = "~> 0.7.0"
    }
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.1"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.19.0" # Current as of April 13th
    }
  }
}

variable "use_kubeconfig" {
  type        = bool
  default     = true
  sensitive   = true
  description = <<-EOF
  Use host kubeconfig? (true/false)

  Set this to false if the Coder host is itself running as a Pod on the same
  Kubernetes cluster as you are deploying workspaces to.

  Set this to true if the Coder host is running outside the Kubernetes cluster
  for workspaces.  A valid "~/.kube/config" must be present on the Coder host.
  EOF
}


variable "namespace" {
  type        = string
  sensitive   = true
  description = "The namespace to create workspaces in (must exist prior to creating workspaces)"
  default     = "coop"
}

locals {
  username = data.coder_workspace.ii.owner
}

provider "kubernetes" {
  # Authenticate via ~/.kube/config or a Coder-specific ServiceAccount, depending on admin preferences
  config_path = var.use_kubeconfig == true ? "~/.kube/config" : null
}

data "coder_provisioner" "ii" {
}

provider "docker" {
}

data "coder_workspace" "ii" {
}

resource "coder_agent" "ii" {
  arch                   = data.coder_provisioner.ii.arch
  os                     = "linux"
  login_before_ready     = false
  startup_script_timeout = 180
  startup_script         = <<-EOT
    set -e
    # start broadwayd and emacs
    broadwayd :5 2>&1 | tee broadwayd.log &
    GDK_BACKEND=broadway BROADWAY_DISPLAY=:5 emacs 2>&1 | tee emacs.log &
    # start ttyd / tmux
    tmux -L ii new -d -s ii -P -F "Welcome to the ${lower(data.coder_workspace.ii.name)} cooperation! Hit q to continue..." -n "${lower(data.coder_workspace.ii.name)}"
    ttyd tmux -L ii at 2>&1 | tee ttyd.log &
    # start code-server
    code-server --auth none --port 13337 | tee code-server-install.log &
  EOT

  # These environment variables allow you to make Git commits right away after creating a
  # workspace. Note that they take precedence over configuration defined in ~/.gitconfig!
  # You can remove this block if you'd prefer to configure Git manually or using
  # dotfiles. (see docs/dotfiles.md)
  env = {
    GIT_AUTHOR_NAME     = "${data.coder_workspace.ii.owner}"
    GIT_COMMITTER_NAME  = "${data.coder_workspace.ii.owner}"
    GIT_AUTHOR_EMAIL    = "${data.coder_workspace.ii.owner_email}"
    GIT_COMMITTER_EMAIL = "${data.coder_workspace.ii.owner_email}"
  }
}



# emacs
resource "coder_app" "emacs" {
  subdomain    = true
  share        = "public"
  agent_id     = coder_agent.ii.id
  slug         = "emacs"
  display_name = "Emacs"
  icon         = "https://upload.wikimedia.org/wikipedia/commons/0/08/EmacsIcon.svg" # let's maybe get an emacs.svg somehow
  url          = "http://localhost:8085"                                             # port 8080 + BROADWAY_DISPLAY
}

# ttyd
resource "coder_app" "ttyd" {
  subdomain    = true
  share        = "public"
  slug         = "ttyd"
  display_name = "ttyd for tmux"
  icon         = "https://cdn.icon-icons.com/icons2/2148/PNG/512/tmux_icon_131831.png"
  agent_id     = coder_agent.ii.id
  url          = "http://localhost:7681" # 7681 is the default ttyd port
}

# tmux
resource "coder_app" "tmux" {
  agent_id     = coder_agent.ii.id
  display_name = "tmux"
  slug         = "tmux"
  icon         = "https://cdn.icon-icons.com/icons2/2148/PNG/512/tmux_icon_131831.png"
  command      = "tmux -L ii at"
  share        = "public"
}

resource "coder_app" "code-server" {
  agent_id     = coder_agent.ii.id
  slug         = "code-server"
  display_name = "code-server"
  # url          = "http://localhost:13337/?folder=/home/${local.username}"
  url       = "http://localhost:13337/?folder=/home/ii"
  icon      = "/icon/code.svg"
  subdomain = false
  share     = "owner"

  healthcheck {
    url       = "http://localhost:13337/healthz"
    interval  = 5
    threshold = 6
  }
}

resource "kubernetes_pod" "iipod" {
  count = data.coder_workspace.ii.start_count
  metadata {
    name      = "coop-${lower(data.coder_workspace.ii.owner)}-${lower(data.coder_workspace.ii.name)}"
    namespace = var.namespace
    labels = {
      name = "coop-${lower(data.coder_workspace.ii.owner)}-${lower(data.coder_workspace.ii.name)}"
    }
  }
  spec {
    security_context {
      run_as_user = "1000"
      fs_group    = "1000"
    }
    container {
      name    = "iipod"
      image   = "this/iikea:latest"
      command = ["sh", "-c", coder_agent.ii.init_script]
      security_context {
        run_as_user = "1000"
      }
      env {
        name  = "CODER_AGENT_TOKEN"
        value = coder_agent.ii.token
      }
    }
  }
}
