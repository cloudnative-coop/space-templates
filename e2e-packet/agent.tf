data "github_actions_organization_registration_token" "runner" {}

resource "coder_agent" "ii" {
  arch = "amd64" # Intel
  # arch = "arm64" # Arm
  os  = "linux" # Linux
  dir = "$HOME" # Could set to somewhere
  # login_before_ready = true
  startup_script = <<EOT
    #!/bin/bash
    echo "Starting TMUX"
    tmux new -d -s "${lower(data.coder_workspace.ii.name)}" -n "ii"
    tmux send-keys "sudo tail -f /var/log/cloud-init-output.log
    "
    echo "Starting TTYD"
    ttyd tmux at 2>&1 | tee /tmp/ttyd.log &
    echo "Setting up repos..."
    mkdir repos
    cd repos
    git clone https://github.com/cncf/apisnoop.git
    git clone https://github.com/apisnoop/ticket-writing.git
    # Setup Ticket-Writing
    cd ~/repos/ticket-writing
    git remote add upstream git@github.com:apisnoop/ticket-writing.git
    # Setup APISnoop
    cd ~/repos/apisnoop
    echo "Waiting for Kubernetes API to be readyz..."
    until kubectl get --raw='/readyz?verbose' ; do sleep 5 ; done
    # Untaint control-plane... we only have one node
    kubectl taint nodes --all node-role.kubernetes.io/control-plane:NoSchedule-
    kubectl get ns apisnoop || kubectl create ns apisnoop
    helm upgrade --install snoopdb -n apisnoop ./charts/snoopdb
    helm upgrade --install auditlogger -n apisnoop ./charts/auditlogger
    # Setup Kubernetes src
    mkdir -p ~/go/src/k8s.io
    cd ~/go/src/k8s.io
    git clone https://github.com/kubernetes/kubernetes.git
    cd kubernetes
    git remote add ii git@github.com:ii/kubernetes.git
    # Setup Istio
    echo "Install istio into this cluster..."
    helm repo add istio https://istio-release.storage.googleapis.com/charts
    helm repo update
    kubectl get ns istio-system || kubectl create ns istio-system
    helm install istio-base istio/base -n istio-system
    kubectl api-resources | grep istio
    helm ls -n istio-system
    helm install istiod istio/istiod -n istio-system --wait
    helm ls -n istio-system
    helm status istiod -n istio-system
    kubectl get deployments -n istio-system --output wide
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
