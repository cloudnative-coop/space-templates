#!/usr/bin/env sh
set -x
echo "Starting TMUX"
tmux new -d -s $SPACE_NAME -n "iipod"
echo "Starting TTYD"
ttyd --writable tmux at 2>&1 | tee /tmp/ttyd.log &
# start broadwayd and emacs with provided ORG @ url
# Check out the repo
git clone "$GIT_REPO"
REPO_DIR=$(basename "$GIT_REPO" | sed 's:.git$::')
GIT_REPO_SSH=$(echo $GIT_REPO | sed 'sXhttps://Xgit@X' | sed 'sX/X:X')
cd $REPO_DIR
# Get our orgfile
wget "$ORGFILE_URL"
ORGFILE=$(basename "$ORGFILE_URL")
# start emacs in repo
echo "Starting Broadwayd"
# Set and export vars ONLY while lauching emacs to display on broadwayd
export GDK_BACKEND=broadway
export BROADWAY_DISPLAY=:5
broadwayd :5 2>&1 | tee /tmp/broadwayd.log &
echo "Starting Emacs GUI"
emacs $ORGFILE 2>&1 | tee /tmp/emacs.log &
unset GDK_BACKEND
unset BROADWAY_DISPLAY
# ensure we can `git push ssh`
mkdir -p ~/.ssh
ssh-keyscan -H github.com >>~/.ssh/known_hosts
git remote add ssh $GIT_REPO_SSH
# start ttyd / tmux
# TODO: don't dump logs into $HOME
# mv code-server-install.log /tmp
# start code-server
mkdir ~/.config/code-server
echo "Starting Code-Server"
code-server --auth none --port 13337 | tee /tmp/code-server.log &
# Check out src
(
  echo "Setting up repos..."
  mkdir ~/repos
  cd ~repos
  git clone https://github.com/cloudnative-coop/space-templates
  cd ~/repos/space-templates
  git remote add upstream git@github.com:cloudnative-coop/space-templates
  # git clone https://github.com/cncf/apisnoop.git
  # Setup Ticket-Writing
  # git clone https://github.com/apisnoop/ticket-writing.git
  # cd ~/repos/ticket-writing
  # git remote add upstream git@github.com:apisnoop/ticket-writing.git

  # Setup Kubernetes src
  # mkdir -p ~/go/src/k8s.io
  # cd ~/go/src/k8s.io
  # git clone https://github.com/kubernetes/kubernetes.git
  # cd kubernetes
  # git remote add ii git@github.com:ii/kubernetes.git
) 2>&1 >/tmp/src-clone.log &
disown
# Go ahead and start http server in a "services"
tmux new -d -s $SESSION_NAME -n "ii"
tmux new -d -s "services" -n "web" python3 -m http.server
# Need to wait for emacs start...
cp -a /usr/share/novnc ~/novnc
cp ~/novnc/vnc.html ~/novnc/index.html
# mkdir ~/novnc && ln -s /usr/share/novnc/* ~/novnc
# cat <<EOF >~/novnc/index.html
# <!DOCTYPE html>
# <html>
#   <head>
# <meta
#   http-equiv="Refresh"
#   content="0; url='https://vnc.$SPACE_DOMAIN/vnc.html?autoconnect=true&resize=remote'" />
#   <body>
#     <p>You will be redirected to <a href="https://vnc.$SPACE_DOMAIN/vnc.html?autoconnect=true&resize=remote">VNC</a> soon!</p>
#   </body>
# </html>
# EOF
tmux new -d -s "vnc" -n "novnc"
tmux send-keys -t "vnc" "websockify -D --web=/home/ii/novnc 6080 localhost:5901
unset GDK_BACKEND # must not be set when using X
export PATH=/usr/local/stow/emacs-x/bin:$PATH
tigervncserver :1 -desktop $SESSION_NAME -SecurityTypes None -xstartup startplasma-x11
export DISPLAY=:1
setterm blank 0
setterm powerdown 0
kwriteconfig5 --file ~/.config/kscreenlockerrc --group Daemon --key Autolock false
xset s 0 0
sudo passwd ii -q <<EOF
ii
ii
EOF
# sleep 5
kitty -T KITTY --detach --hold --start-as=maximized bash -c 'tmux at'
"
sleep 15
tmux new -d -s "emacs" -n "emacs" emacsclient -nw .
exit 0
