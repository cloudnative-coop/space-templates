#!/bin/bash
echo "Starting TMUX"
tmux new -d -s $SESSION_NAME -n "ii"
tmux send-keys "sudo tail -F /var/log/cloud-init-output.log /var/log/k8s-deploy.log /var/log/install-desktop.log ~/.config/emacs-install.log
"
# tmux neww -n "iii"
echo "Starting TTYD"
ttyd tmux at 2>&1 | tee /tmp/ttyd.log &
# TODO : Install docker into the image
(
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
) 2>&1 >/tmp/src-clone.log &

echo "Waiting for emacs to be available"
until emacs --version; do sleep 5; done
mkdir -p ~/.config
(
    git clone --depth 1 https://github.com/doomemacs/doomemacs ~/.config/emacs
    git clone --depth 1 https://github.com/ii/doom-config ~/.config/doom
    yes | ~/.config/emacs/bin/doom install --env --fonts
    yes | ~/.config/emacs/bin/doom sync
    echo "Waiting for emacs && gnome-session to be available"
    until gnome-session --version; do sleep 10; done
    # And maybe 60 seconds? Not sure why we get the x-terminal-emulator
    sleep 60 # FIXME (turn off and figure out what it is we are actually waiting for)
    tmux neww -n "vnc"
    tmux send-keys -t "vnc" "websockify -D --web=/home/ii/novnc 6080 localhost:5901
tigervncserver :1 -desktop $SESSION_NAME -SecurityTypes None
sleep 5
wget $ORGURL
ORGFILE=$(basename $ORGURL)
emacs \$ORGFILE &
"
) 2>&1 >~/.config/emacs-install.log &
mkdir ~/novnc && ln -s /usr/share/novnc/* ~/novnc
cp ~/novnc/vnc.html ~/novnc/index.html

echo "Waiting for kubectl to be installed"
until kubectl version; do sleep 5; done
cat <<EOF >>~/.bashrc
source <(kubectl completion bash)
alias k=kubectl
complete -o default -F __start_kubectl k
EOF
echo "source <(kubectl completion bash)" >>~/.bashrc
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

# sleep 30
# tmux send-keys -t "vnc" "
# ps ax | grep gnome
# tigervncserver :1 -kill
# tigervncserver :1 -desktop $SESSION_NAME -SecurityTypes None
# "
# sleep 30
# tmux send-keys -t "vnc" "
# ps ax | grep gnome
# tigervncserver :1 -kill
# tigervncserver :1 -desktop $SESSION_NAME -SecurityTypes None
# "
# We don't want this popping up... maybe we can tag to NOT install
# Get rid of the inital-setup-first-login
# systemctl --user --now mask gnome-initial-setup-first-login.service
# When we start this up currently, it's defaulting to xterminal
# sleep 30 # So maybe wait a bit #TODO figure out why it's only starting x-terminal-emulator
# # We already wait, but maywe we double check /etc/X11/Xsession.d/50x11-common_determine-startup
# # If it can't find /usr/bin/x-session-manager (which /etc/alternatives to gnome-session)
# # THEN it will start x-terminal-emulator... which is what seems to be happening
# cd ~/
# cat <<EOF >~/.xsession
# while true; do
#  gnome-session
# done
# EOF
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
# Wait until we can clone git@$(hostname):space-templates
# And feed it to flux
