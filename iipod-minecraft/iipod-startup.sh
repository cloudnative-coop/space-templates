#!/usr/bin/env sh
set -x
echo "Starting TMUX"
tmux new -d -s $SPACE_NAME -n "iipod"
echo "Starting TTYD"
ttyd tmux at 2>&1 | tee /tmp/ttyd.log &

cp -a /usr/share/novnc ~/novnc
cp ~/novnc/vnc.html ~/novnc/index.html

tmux new -d -s "vnc" -n "novnc"
tmux send-keys -t "vnc" "websockify -D --web=/home/ii/novnc 6080 localhost:5901
export PATH=/usr/local/stow/emacs-x/bin:$PATH
tigervncserver :1 -desktop $SESSION_NAME -SecurityTypes None  -xstartup startplasma-x11
qdbus org.kde.plasmashell /PlasmaShell org.kde.PlasmaShell.evaluateScript 'string: desktops().forEach(function(d) { d.wallpaperPlugin = \"org.kde.image\"; d.currentConfigGroup = Array(\"Wallpaper\", \"org.kde.image\", \"General\"); d.writeConfig(\"Image\", \"file:///https://apod.nasa.gov/apod/image/2306/MavenMars2panel.png\") });'
"
# Set the desired password
password="ii"
echo -e "$password\n$password" | sudo passwd ii

#qdbus org.kde.plasmashell /PlasmaShell org.kde.PlasmaShell.evaluateScript 'string:
#desktops().forEach(function(d) { d.wallpaperPlugin = "org.kde.image"; d.currentConfigGroup = Array("Wallpaper", "org.kde.image", "General"); d.writeConfig("Image", "file:///https://apod.nasa.gov/apod/image/2306/MavenMars2panel.png") });'
exit 0
