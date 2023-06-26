
# variable "namespace" {
#   type        = string
#   sensitive   = true
#   description = "The namespace to create workspaces in (must exist prior to creating workspaces)"
#   default     = "spaces"
# }

locals {
  username = data.coder_workspace.ii.owner
}

data "coder_provisioner" "ii" {
}

provider "docker" {
}

data "coder_workspace" "ii" {
}

# data "coder_git_auth" "github" {
#   # Matches the ID of the git auth provider in Coder.
#   id = "primary-github"
# }
