resource "coder_agent" "iipod" {
  arch                    = data.coder_provisioner.ii.arch
  os                      = data.coder_provisioner.ii.os
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
    # Just a hidden feature for now to try out
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
