#!/bin/bash
echo "Starting TMUX"
tmux new -d -s $SESSION_NAME -n "ii"
tmux send-keys "sudo tail -f /var/log/cloud-init-output.log
"
echo "Starting TTYD"
ttyd tmux at 2>&1 | tee /tmp/ttyd.log &
# TODO : Install docker into the image
sudo apt install docker-ce-cli
echo "Setting up repos..."
mkdir repos
cd repos
git clone https://github.com/cncf/apisnoop.git
# Setup Ticket-Writing
git clone https://github.com/apisnoop/ticket-writing.git
cd ~/repos/ticket-writing
git remote add upstream git@github.com:apisnoop/ticket-writing.git
echo "Waiting for Kubernetes API to be readyz..."
until kubectl get --raw='/readyz?verbose'; do sleep 5; done
# Setup Kubernetes src
mkdir -p ~/go/src/k8s.io
cd ~/go/src/k8s.io
git clone https://github.com/kubernetes/kubernetes.git
cd kubernetes
git remote add ii git@github.com:ii/kubernetes.git
