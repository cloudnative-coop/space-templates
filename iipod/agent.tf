resource "coder_agent" "ii" {
  arch                   = data.coder_provisioner.ii.arch
  os                     = data.coder_provisioner.ii.os
  login_before_ready     = true
  startup_script_timeout = 180
  startup_script         = <<-EOT
    set -e
    # start broadwayd and emacs with provided ORG @ url
    broadwayd :5 2>&1 | tee /tmp/broadwayd.log &
    wget "${data.coder_parameter.org-url.value}"
    ORGFILE=$(basename "${data.coder_parameter.org-url.value}")
    GDK_BACKEND=broadway BROADWAY_DISPLAY=:5 emacs $ORGFILE 2>&1 | tee /tmp/emacs.log &
    # start ttyd / tmux
    tmux new -d -s "${lower(data.coder_workspace.ii.name)}" -n "ii"
    ttyd tmux at 2>&1 | tee /tmp/ttyd.log &
    # TODO: don't dump logs into $HOME
    mv code-server-install.log /tmp
    # start code-server
    mkdir ~/.config/code-server
    cat <<-EOF > ~/.config/code-server/config.yaml
    bind-addr: 127.0.0.1:8080
    auth: none
    cert: false
    disable-telemetry: true
    disable-update-check: true
    disable-workspace-trust: true
    disable-getting-started-override: true
    app-name: coop-code
    EOF
    code-server --auth none --port 13337 | tee /tmp/code-server.log &
    echo startup_script complete | tee /tmp/startup_script.exit
    # Check out the repo
    git clone "${data.coder_parameter.git-url.value}"
    exit 0
  EOT

  # These environment variables allow you to make Git commits right away after creating a
  # workspace. Note that they take precedence over configuration defined in ~/.gitconfig!
  # You can remove this block if you'd prefer to configure Git manually or using
  # dotfiles. (see docs/dotfiles.md)
  env = {
    # GITHUB_TOKEN        = "$${data.coder_git_auth.github.access_token}"
    SESSION_NAME        = "${lower(data.coder_workspace.ii.name)}"
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
