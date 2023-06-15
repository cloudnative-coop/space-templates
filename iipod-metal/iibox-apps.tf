# ttyd connecting to tmux
resource "coder_app" "tmuxt" {
  subdomain    = true
  share        = "public"
  slug         = "tmuxs"
  display_name = "TMUX"
  icon         = "https://cdn.icon-icons.com/icons2/2148/PNG/512/tmux_icon_131831.png"
  agent_id     = coder_agent.iibox.id
  url          = "http://localhost:7681" # 7681 is the default ttyd port
}

# # noVNC connecting to tigervnc:1
resource "coder_app" "vnct" {
  subdomain    = true
  share        = "public"
  slug         = "vncs"
  display_name = "VNC:1"
  icon         = "/icon/novnc.svg"
  agent_id     = coder_agent.iibox.id
  url          = "http://localhost:6080?resize=remote&autoconnect=true"
}
