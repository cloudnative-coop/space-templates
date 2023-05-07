# vnc
resource "coder_app" "minecraft" {
  subdomain    = true
  share        = "public"
  agent_id     = coder_agent.ii.id
  slug         = "minecraft"
  display_name = "Minecraft"
  icon         = "https://raw.githubusercontent.com/devoxx4kids/materials/master/workshops/minecraft/images/forge-logo.png"
  url          = "http://localhost:6080?autoconnect=true"
}

# emacs
resource "coder_app" "emacs" {
  subdomain    = true
  share        = "public"
  agent_id     = coder_agent.ii.id
  slug         = "emacs"
  display_name = "Emacs"
  icon         = "https://upload.wikimedia.org/wikipedia/commons/0/08/EmacsIcon.svg" # let's maybe get an emacs.svg somehow
  url          = "http://localhost:8085"                                             # port 8080 + BROADWAY_DISPLAY
}

# ttyd
resource "coder_app" "ttyd" {
  subdomain    = true
  share        = "public"
  slug         = "ttyd"
  display_name = "ttyd for tmux"
  icon         = "https://upload.wikimedia.org/wikipedia/commons/0/08/EmacsIcon.svg" # let's maybe get an emacs.svg somehow
  agent_id     = coder_agent.ii.id
  url          = "http://localhost:7681" # 7681 is the default ttyd port
}

resource "coder_app" "code-server" {
  agent_id     = coder_agent.ii.id
  slug         = "code-server"
  display_name = "code-server"
  # url          = "http://localhost:13337/?folder=/home/${local.username}"
  url  = "http://localhost:13337/?folder=/home/ii"
  icon = "/icon/code.svg"
  # share     = "owner"
  share     = "public"
  subdomain = true

  healthcheck {
    url       = "http://localhost:13337/healthz"
    interval  = 5
    threshold = 6
  }
}
