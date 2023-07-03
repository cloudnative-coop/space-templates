data "coder_parameter" "container-image" {
  name         = "container-image"
  display_name = "Container Image"
  description  = "The container image to use for the workspace"
  # default      = "ghcr.io/cloudnative-coop/iipod:v0.0.12"
  # default = "ghcr.io/cloudnative-coop/iipod:kubedaytlv"
  default = "ghcr.io/cloudnative-coop/iipod:2023.07.03-hh"
  icon    = "https://raw.githubusercontent.com/matifali/logos/main/docker.svg"
}

data "coder_parameter" "git-url" {
  name         = "git-url"
  display_name = "Git URL"
  description  = "The Git URL to checkout for this workspace"
  default      = "https://github.com/cncf-infra/infrasnoop"
  # icon         = "https://raw.githubusercontent.com/matifali/logos/main/docker.svg"
}

data "coder_parameter" "org-url" {
  name         = "org-url"
  display_name = "Orgfile url"
  description  = "The Orgfile URL to load into emacs"
  default      = "https://raw.githubusercontent.com/ii/org/infrapisnoop/infra-api-snoop.org"
  # icon         = "https://raw.githubusercontent.com/matifali/logos/main/docker.svg"
}

resource "coder_agent" "iipod" {
  auth                    = "token"
  arch                    = "amd64" # Intel
  os                      = "linux" # Linux
  dir                     = "$HOME" # Could set to somewhere
  motd_file               = "/etc/motd"
  startup_script_behavior = "blocking"     # blocking, non-blocking
  troubleshooting_url     = "http://ii.nz" # blocking, non-blocking
  connection_timeout      = 300
  startup_script          = file("./iipod-startup.sh")
  startup_script_timeout  = 300
  shutdown_script         = "#!/bin/sh\necho Box is on it's way down!"
  shutdown_script_timeout = 300
  env = {
    # GITHUB_TOKEN        = "$${data.coder_git_auth.github.access_token}"
    # GITHUB_TOKEN        = "$${var.GITHUB_TOKEN}"
    OPENAI_API_TOKEN    = "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"
    ORGFILE_URL         = "${data.coder_parameter.org-url.value}"
    SESSION_NAME        = "${lower(data.coder_workspace.ii.name)}"
    GIT_REPO            = "${data.coder_parameter.git-url.value}"
    SPACE_DOMAIN        = "${local.dns_fqdn}"
    GIT_AUTHOR_NAME     = "${data.coder_workspace.ii.owner}"
    GIT_COMMITTER_NAME  = "${data.coder_workspace.ii.owner}"
    GIT_AUTHOR_EMAIL    = "${data.coder_workspace.ii.owner_email}"
    GIT_COMMITTER_EMAIL = "${data.coder_workspace.ii.owner_email}"
  }
  metadata {
    key          = "tmux-clients"
    display_name = "tmux clients"
    interval     = 5
    timeout      = 5
    script       = <<-EOT
      #!/bin/bash
      set -e
      tmux list-clients -F "#{client_session}:#{client_width}x#{client_height}" | xargs echo
    EOT
  }
  metadata {
    key          = "tmux-windows"
    display_name = "tmux windows"
    interval     = 5
    timeout      = 5
    script       = <<-EOT
      #!/bin/bash
      set -e
      tmux list-windows -F "#{window_index}:#{window_name}" | xargs echo
    EOT
  }
}


resource "coder_metadata" "iipod" {
  resource_id = null_resource.iipod.id
  count       = data.coder_workspace.ii.start_count
  icon        = "/icon/k8s.png"
  item {
    key   = "ssh"
    value = "ssh -tA ii@${powerdns_record.a_record.name} kubectl exec -ti iipod-0 -- tmux at"
  }
  item {
    key   = "kubexec"
    value = "export KUBECONFIG=$(mktemp) ; scp ii@${powerdns_record.a_record.name}:.kube/config $KUBECONFIG ; kubectl exec -ti iipod-0 -- tmux at"
  }
}

# # emacs
resource "coder_app" "Emacs" {
  subdomain    = true
  share        = "public"
  agent_id     = coder_agent.iipod.id
  slug         = "emacs"
  display_name = "iipod:Emacs Broadway"
  icon         = "https://upload.wikimedia.org/wikipedia/commons/0/08/EmacsIcon.svg" # let's maybe get an emacs.svg somehow
  url          = "http://localhost:8085"                                             # port 8080 + BROADWAY_DISPLAY
}

# ttyd connecting to tmux
resource "coder_app" "podmux" {
  subdomain    = true
  share        = "public"
  slug         = "podtmux"
  display_name = "iipod:tmux"
  icon         = "https://cdn.icon-icons.com/icons2/2148/PNG/512/tmux_icon_131831.png"
  agent_id     = coder_agent.iipod.id
  url          = "http://localhost:7681" # 7681 is the default ttyd port
}
# ttyd connecting to tmux
resource "coder_app" "web" {
  subdomain    = true
  share        = "public"
  slug         = "podweb"
  display_name = "iipod:web"
  icon         = "https://cdn.icon-icons.com/icons2/2148/PNG/512/tmux_icon_131831.png"
  agent_id     = coder_agent.iipod.id
  url          = "http://localhost:8000" # python -m http.server
}
# # # noVNC connecting to tigervnc:1
# resource "coder_app" "podvnc" {
#   subdomain    = true
#   share        = "public"
#   slug         = "podvnc"
#   display_name = "VNC:1"
#   icon         = "/icon/novnc.svg"
#   agent_id     = coder_agent.iipod.id
#   url          = "http://localhost:6080?resize=remote&autoconnect=true"
# }

# NULL RESOURCE for iipod
# agent_token / startup in local RATHER than directly
# So the NULL resource can point it
# CODER wants agents tied directly to terraform provisioned resources

resource "null_resource" "iipod" {
  triggers = {
    value = coder_agent.iipod.token
  }
  provisioner "local-exec" {
    command = "echo iipod.token: ${coder_agent.iipod.token}"
  }
}

# This would look nicer:::
# resource "kubernetes_pod" "iipod" {
#   triggers = {
#     value = coder_agent.iipod.token
#   }
#   provisioner "local-exec" {
#     command = "echo iipod.token: ${coder_agent.iipod.token}"
#   }
#   # This isn't actually a kubernetes_pod
#   # We use the null.null_resource provider
#   # because we don't have the kubeconfig yet
#   # https://developer.hashicorp.com/terraform/language/meta-arguments/resource-provider
#   provider = null.null_resource
# }
