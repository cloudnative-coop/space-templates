data "github_actions_organization_registration_token" "runner" {}

resource "coder_agent" "ii" {
  arch = "amd64" # Intel
  # arch = "arm64" # Arm
  os  = "linux" # Linux
  dir = "$HOME" # Could set to somewhere
  # login_before_ready = true
  startup_script = <<EOT
    #!/bin/bash
    # start ttyd / tmux
    tmux new -d -s "${lower(data.coder_workspace.ii.name)}" -n "ii"
    ttyd tmux at 2>&1 | tee /tmp/ttyd.log &
    tmux send-keys "sudo tail -f /var/log/cloud-init-output.log
    "
    # Create the runner and start the configuration experience
    # ./config.sh --url https://github.com/cloudnative-coop --token "${data.github_actions_organization_registration_token.runner.token}"
    # Last step, run it!
    # ./run.sh 2&>1 | tee /tmp/runner.log &
  EOT
  env = {
    # GITHUB_TOKEN        = "$${data.coder_git_auth.github.access_token}"
    # GITHUB_TOKEN        = "$${var.GITHUB_TOKEN}"
    SESSION_NAME        = "${lower(data.coder_workspace.ii.name)}"
    GIT_AUTHOR_NAME     = "${data.coder_workspace.ii.owner}"
    GIT_COMMITTER_NAME  = "${data.coder_workspace.ii.owner}"
    GIT_AUTHOR_EMAIL    = "${data.coder_workspace.ii.owner_email}"
    GIT_COMMITTER_EMAIL = "${data.coder_workspace.ii.owner_email}"
  }
}
