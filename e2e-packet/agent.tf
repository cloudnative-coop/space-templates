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
    tmux send-keys "sudo tail -f /var/log/cloud-init-output.log
    "
    ttyd tmux at 2>&1 | tee /tmp/ttyd.log &
    # # Runner Setup
    # mkdir actions-runner && cd actions-runner
    # # Download the latest runner package
    # curl -o actions-runner-linux-arm64-2.304.0.tar.gz -L https://github.com/actions/runner/releases/download/v2.304.0/actions-runner-linux-arm64-2.304.0.tar.gz
    # # Optional: Validate the hash
    # echo "34c49bd0e294abce6e4a073627ed60dc2f31eee970c13d389b704697724b31c6  actions-runner-linux-arm64-2.304.0.tar.gz" | shasum -a 256 -c
    # # Extract the installer
    # tar xzf ./actions-runner-linux-arm64-2.304.0.tar.gz
    # # Create the runner and start the configuration experience
    # ./config.sh --url https://github.com/cloudnative-coop --token "${data.github_actions_organization_registration_token.runner.token}"
    # # Last step, run it!
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
