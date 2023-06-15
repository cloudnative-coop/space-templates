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
sudo apt-get install -y docker-ce-cli
exit 0
