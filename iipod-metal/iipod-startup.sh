#!/usr/bin/env sh
set -e
cat <<EOF >>~/.tmux.conf
set -g base-index 1
set -s escape-time 0
EOF
echo "Starting TMUX"
tmux new -d -s $SPACE_NAME -n "iipod"
echo "Starting TTYD"
ttyd tmux at 2>&1 | tee /tmp/ttyd.log &
# start broadwayd and emacs with provided ORG @ url
broadwayd :5 2>&1 | tee /tmp/broadwayd.log &
wget $ORGURL
ORGFILE=$(basename $ORGURL)
GDK_BACKEND=broadway BROADWAY_DISPLAY=:5 emacs $ORGFILE 2>&1 | tee /tmp/emacs.log &
# start ttyd / tmux
# TODO: don't dump logs into $HOME
# mv code-server-install.log /tmp
# start code-server
mkdir ~/.config/code-server
cat <<-EOF >~/.config/code-server/config.yaml
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
# Check out the repo
git clone $GITURL
# TODO : Install docker into the image
sudo apt-get install -y docker-ce-cli
# Check out src
(
    echo "Setting up repos..."
    mkdir repos
    cd repos
    # git clone https://github.com/cncf/apisnoop.git
    # Setup Ticket-Writing
    git clone https://github.com/apisnoop/ticket-writing.git
    cd ~/repos/ticket-writing
    git remote add upstream git@github.com:apisnoop/ticket-writing.git

    # Setup Kubernetes src
    # mkdir -p ~/go/src/k8s.io
    # cd ~/go/src/k8s.io
    # git clone https://github.com/kubernetes/kubernetes.git
    # cd kubernetes
    # git remote add ii git@github.com:ii/kubernetes.git
) 2>&1 >/tmp/src-clone.log &
curl -s https://fluxcd.io/install.sh | bash
cat <<EOF >>~/.bashrc
. <(kubectl completion bash)
. <(flux completion bash)
EOF
exit 0
