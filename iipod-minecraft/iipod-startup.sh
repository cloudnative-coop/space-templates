#!/usr/bin/env sh
set -x
echo "Starting TMUX"
tmux new -d -s $SPACE_NAME -n "iipod"
echo "Starting TTYD"
ttyd tmux at 2>&1 | tee /tmp/ttyd.log &

# start broadwayd and emacs with provided ORG @ url
# Get our orgfile
wget "$ORGFILE_URL"
ORGFILE=$(basename "$ORGFILE_URL")
# Check out the repo
git clone "$GIT_REPO"
REPO_DIR=$(basename "$GIT_REPO" | sed 's:.git$::')
GIT_REPO_SSH=$(echo $GIT_REPO | sed 'sXhttps://Xgit@X' | sed 'sX/X:X')
cd $REPO_DIR
# start emacs in repo
echo "Starting Broadwayd"
# Set and export vars ONLY while lauching emacs to display on broadwayd
export GDK_BACKEND=broadway
export BROADWAY_DISPLAY=:5
broadwayd :5 2>&1 | tee /tmp/broadwayd.log &
echo "Starting Emacs GUI"
emacs . 2>&1 | tee /tmp/emacs.log &
unset GDK_BACKEND
unset BROADWAY_DISPLAY
# ensure we can `git push ssh`
mkdir -p ~/.ssh
ssh-keyscan -H github.com >>~/.ssh/known_hosts
git remote add ssh $GIT_REPO_SSH

cp -a /usr/share/novnc ~/novnc
# mkdir ~/novnc && ln -s /usr/share/novnc/* ~/novnc
cat <<EOF >~/novnc/index.html
<!DOCTYPE html>
<html>
  <head>
<meta
  http-equiv="Refresh"
  content="0; url='https://vnc.$SPACE_DOMAIN/vnc.html?autoconnect=true&resize=remote'" />
<style>
#loading-circle {
  border: 4px solid #f3f3f3;
  border-top: 4px solid rgb(4, 255, 4);
  border-radius: 50%;
  width: 40px;
  height: 40px;
  animation: spin 1s linear infinite;
}
body {
    background: linear-gradient(to bottom, yellow, blue);
    margin: 0;
    padding: 0;
    height:100vh;
    font-size: 40px;
    font-family: Arial, Helvetica, Calibri, sans-serif;
    color:white;
}
.centered {
    position: absolute;
    top: 50%;
    left: 50%;
    transform: translate(-50%,-50%);
    display:flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;
}
.ml-50{
    margin-left: 50px;
}
@keyframes spin {
  0% { transform: rotate(0deg); }
  100% { transform: rotate(360deg); }
}

</style>
<body>
    <div class="centered">
        <p>You will be redirected to <a href="https://vnc.$SPACE_DOMAIN/vnc.html?autoconnect=true&resize=remote">VNC</a> soon!</p>
        <div id="loading-circle"></div>
    </div>
 </body>
<script>
  document.getElementById("loading-circle").style.display = "block";
</script>
</html>
EOF

tmux new -d -s "vnc" -n "novnc"
tmux send-keys -t "vnc" "websockify -D --web=/home/ii/novnc 6080 localhost:5901
unset GDK_BACKEND # must not be set when using X
export PATH=/usr/local/stow/emacs-x/bin:$PATH
tigervncserver :1 -desktop $SESSION_NAME -SecurityTypes None  -xstartup startplasma-x11
# sleep 5
# kitty -T KITTY --detach --hold bash -c 'tmux at'
qdbus org.kde.plasmashell /PlasmaShell org.kde.PlasmaShell.evaluateScript 'string: desktops().forEach(function(d) { d.wallpaperPlugin = \"org.kde.image\"; d.currentConfigGroup = Array(\"Wallpaper\", \"org.kde.image\", \"General\"); d.writeConfig(\"Image\", \"file:///https://apod.nasa.gov/apod/image/2306/MavenMars2panel.png\") });'
"
# Set the desired password
password="ii"
echo -e "$password\n$password" | sudo passwd ii

#qdbus org.kde.plasmashell /PlasmaShell org.kde.PlasmaShell.evaluateScript 'string:
#desktops().forEach(function(d) { d.wallpaperPlugin = "org.kde.image"; d.currentConfigGroup = Array("Wallpaper", "org.kde.image", "General"); d.writeConfig("Image", "file:///https://apod.nasa.gov/apod/image/2306/MavenMars2panel.png") });'
exit 0
