#!/usr/bin/env sh
set -x
cat <<EOF >>~/.tmux.conf
# set -g base-index 1
set -s escape-time 0
EOF
# start ttyd / tmux
ttyd tmux at -t $SESSION_NAME 2>&1 | tee /tmp/ttyd.log &
# start broadwayd and emacs with provided ORG @ url
broadwayd :5 2>&1 | tee /tmp/broadwayd.log &
# Get our orgfile
wget "$ORGFILE_URL"
ORGFILE=$(basename "$ORGFILE_URL")
# Check out the repo
git clone "$GIT_REPO"
REPO_DIR=$(basename "$GIT_REPO" | sed 's:.git$::')
GIT_REPO_SSH=$(echo $GIT_REPO | sed 'sXhttps://Xgit@X' | sed 'sX/X:X')
cd $REPO_DIR
# ensure we can `git push ssh`
mkdir -p ~/.ssh
ssh-keyscan -H github.com >>~/.ssh/known_hosts
git remote add ssh $GIT_REPO_SSH
# start emacs in repo
emacs . 2>&1 | tee /tmp/emacs.log &
# GDK_BACKEND=broadway BROADWAY_DISPLAY=:5 emacs $ORGFILE 2>&1 | tee /tmp/emacs.log &
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
# Let's get this working later
# sudo apt-get install -y \
#   tigervnc-standalone-server \
#   apt-file \
#   dbus-x11
# sudo apt-file update
# mkdir ~/novnc && ln -s /usr/share/novnc/* ~/novnc
# cp ~/novnc/vnc.html ~/novnc/index.html
# websockify -D --web=/home/ii/novnc 6080 localhost:5901
# tigervncserver :1 -desktop $SESSION_NAME -SecurityTypes None -noxstartup
# Go ahead and start http server in a "services"
tmux new -d -s $SESSION_NAME -n "ii"
tmux new -d -s "services" -n "web" python3 -m http.server
# Need to wait for emacs start...
sleep 5
tmux new -d -s "emacs" -n "emacs" emacsclient -nw $ORGFILE
exit 0
