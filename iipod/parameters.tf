# I'd like to be able to turn off/on DNS+TLS
# as necessary to speed deployment when iterating
# data "coder_parameter" "dns" {
#   name         = "dns"
#   display_name = "dns"
#   description  = "Create a DNS wildcard + TLS Certificate (adds 30-40 seconds)"
#   default      = true
#   type         = "bool"
#   icon         = "https://github.com/cncf/artwork/blob/master/projects/coredns/icon/solid-color/coredns-icon-solid-color.png?raw=true"
#   # option {
#   #   name  = "True"
#   #   value = true
#   # }
#   # option {
#   #   name  = "False"
#   #   value = false
#   # }
# }

data "coder_parameter" "container-image" {
  name         = "container-image"
  display_name = "Container Image"
  description  = "The container image to use for the workspace"
  default      = "ghcr.io/cloudnative-coop/iipod:2023.07.04-05"
  icon         = "https://raw.githubusercontent.com/matifali/logos/main/docker.svg"
}

data "coder_parameter" "git-url" {
  name         = "git-url"
  display_name = "Git URL"
  description  = "The Git URL to checkout for this workspace"
  default      = "https://github.com/cloudnative-nz/infra"
  # icon         = "https://raw.githubusercontent.com/matifali/logos/main/docker.svg"
}

data "coder_parameter" "org-url" {
  name         = "org-url"
  display_name = "Orgfile url"
  description  = "The Orgfile URL to load into emacs"
  default      = "https://raw.githubusercontent.com/cloudnative-nz/infra/main/iipod/demo.org"
  # icon         = "https://raw.githubusercontent.com/matifali/logos/main/docker.svg"
}
