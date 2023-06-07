# ttyd
resource "coder_app" "tmux" {
  subdomain    = true
  share        = "public"
  slug         = "tmux"
  display_name = "tmux"
  icon         = "https://cdn.icon-icons.com/icons2/2148/PNG/512/tmux_icon_131831.png"
  agent_id     = coder_agent.ii.id
  url          = "http://localhost:7681" # 7681 is the default ttyd port
}
