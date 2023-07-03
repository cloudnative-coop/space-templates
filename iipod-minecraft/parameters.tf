data "coder_parameter" "container-image" {
  name         = "container-image"
  display_name = "Container Image"
  description  = "The container image to use for the workspace"
  default      = "ghcr.io/cloudnative-coop/iipod-minecraft:2023.07.04-1"
  icon         = "https://raw.githubusercontent.com/matifali/logos/main/docker.svg"
}
