# FIXME: When using multiple coder_agents
# adding ANY coder_apps causes coder template create/push
# to HANG on ✔ Detecting ephemeral resources [13906ms]
# > ⧗  Cleaning Up
# ttyd connecting to tmux
resource "coder_app" "podmux" {
  subdomain    = true
  share        = "public"
  slug         = "podtmux"
  display_name = "Tmux"
  icon         = "https://cdn.icon-icons.com/icons2/2148/PNG/512/tmux_icon_131831.png"
  agent_id     = coder_agent.iipod.id
  url          = "http://localhost:7681" # 7681 is the default ttyd port
}

# # emacs
resource "coder_app" "Emacs" {
  subdomain    = true
  share        = "public"
  agent_id     = coder_agent.ii.id
  slug         = "emacs"
  display_name = "Emacs"
  icon         = "https://upload.wikimedia.org/wikipedia/commons/0/08/EmacsIcon.svg" # let's maybe get an emacs.svg somehow
  url          = "http://localhost:8085"                                             # port 8080 + BROADWAY_DISPLAY
}

# # noVNC connecting to tigervnc:1
resource "coder_app" "podvnc" {
  subdomain    = true
  share        = "public"
  slug         = "podvnc"
  display_name = "VNC:1"
  icon         = "/icon/novnc.svg"
  agent_id     = coder_agent.iipod.id
  url          = "http://localhost:6080?resize=remote&autoconnect=true"
}
# # noVNC connecting to tigervnc:2
# resource "coder_app" "poddesktop" {
#   subdomain    = true
#   share        = "public"
#   slug         = "podubuntu"
#   display_name = "Ubuntu Desktop"
#   icon         = "/icon/ubuntu.svg"
#   agent_id     = coder_agent.iipod.id
#   url          = "http://localhost:6081?resize=remote&autoconnect=true"
# }
