#!/bin/bash
echo "Starting TMUX"
tmux new -d -s $SESSION_NAME -n "ii"
tmux send-keys "sudo tail -F /var/log/cloud-init-output.log /var/log/k8s-deploy.log /var/log/install-desktop.log
"
# tmux neww -n "iii"
echo "Starting TTYD"
ttyd tmux at 2>&1 | tee /tmp/ttyd.log &
git config --global commit.template ~/.gitmessage
cat <<EOF >~/.gitmessage
# Title: Summary, imperative, start upper case, don't end with a period
# No more than 50 chars. #### 50 chars is here:  #

# Remember blank line between title and body.

# Body: Explain *what* and *why* (not *how*). Include task ID (Jira issue).
# Wrap at 72 chars. ################################## which is here:  #


# At the end: Include Co-authored-by for all contributors.
# Include at least one empty line before it. Format:
# Co-authored-by: name <user@users.noreply.github.com>
#
# How to Write a Git Commit Message:
# https://chris.beams.io/posts/git-commit/
#
# 1. Separate subject from body with a blank line
# 2. Limit the subject line to 50 characters
# 3. Capitalize the subject line
# 4. Do not end the subject line with a period
# 5. Use the imperative mood in the subject line
# 6. Wrap the body at 72 characters
# 7. Use the body to explain what and why vs. how
EOF
# TODO : Install docker into the image
echo "Setting up repos..."
mkdir repos
cd repos
git clone https://github.com/cncf/apisnoop.git
# Setup Ticket-Writing
git clone https://github.com/apisnoop/ticket-writing.git
cd ~/repos/ticket-writing
git remote add upstream git@github.com:apisnoop/ticket-writing.git
# Setup Kubernetes src
mkdir -p ~/go/src/k8s.io
cd ~/go/src/k8s.io
git clone https://github.com/kubernetes/kubernetes.git
cd kubernetes
git remote add ii git@github.com:ii/kubernetes.git
# sudo apt-get install -y novnc websockify tigervnc-standalone-server icewm kitty
# mkdir novnc && ln -s /usr/share/novnc/* novnc
# cp novnc/vnc.html novnc/index.html
# websockify -D --web=/home/ii/novnc 6080 localhost:5901
# tigervncserver -useold -desktop $SESSION_NAME -SecurityTypes None#
# export DISPLAY=:1
# kitty -T "${lower(data.coder_workspace.ii.name)}" --detach --hold bash -c "cd minecraftforge && ./gradlew runClient"
echo "Waiting for Kubernetes API to be readyz..."
until kubectl get --raw='/readyz?verbose'; do sleep 5; done
echo "Waiting for gnome-session to be available"
until gnome-session --version; do sleep 5; done
mkdir novnc && ln -s /usr/share/novnc/* novnc
cp novnc/vnc.html novnc/index.html
websockify -D --web=/home/ii/novnc 6080 localhost:5901
tigervncserver -useold -desktop $SESSION_NAME -SecurityTypes None
# Setup Istio
# echo "Install istio into this cluster..."
# helm repo add istio https://istio-release.storage.googleapis.com/charts
# helm repo update
# kubectl get ns istio-system || kubectl create ns istio-system
# helm install istio-base istio/base -n istio-system
# kubectl api-resources | grep istio
# helm ls -n istio-system
# helm install istiod istio/istiod -n istio-system --wait
# helm ls -n istio-system
# helm status istiod -n istio-system
# kubectl get deployments -n istio-system --output wide
# Setup Knative
# echo "Install knative into this cluster..."
# kubectl apply -f https://github.com/knative/serving/releases/download/knative-v1.10.2/serving-crds.yaml
# kubectl apply -f https://github.com/knative/serving/releases/download/knative-v1.10.2/serving-core.yaml
# kubectl apply -f https://github.com/knative/net-istio/releases/download/knative-v1.10.1/net-istio.yaml
# kubectl --namespace istio-system get service istio-ingressgateway
# kubectl get pods -n knative-serving
