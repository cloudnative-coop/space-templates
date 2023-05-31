terraform {
  required_providers {
    coder = {
      source  = "coder/coder"
      version = "~> 0.7.0"
    }
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.2"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.20.0" # Current as of April 13th
    }
  }
}

locals {
  username = data.coder_workspace.ii.owner
}

provider "kubernetes" {
  # Authenticate via ~/.kube/config or a Coder-specific ServiceAccount, depending on admin preferences
  # config_path = var.use_kubeconfig == true ? "~/.kube/config" : null
  # To use ~/.kube/config please set KUBE_CONFIG variable to "$HOME/.kube/config" or similar
  # config_path = "~/.kube/config"
}

data "coder_provisioner" "ii" {
}

provider "docker" {
}

data "coder_workspace" "ii" {
}

# data "coder_git_auth" "github" {
#   # Matches the ID of the git auth provider in Coder.
#   id = "github"
# }

locals {
    repo_folder_name = try(element(split("/", data.coder_parameter.git_url.value), length(split("/", data.coder_parameter.git_url.value)) - 1), "")
}

data "coder_parameter" "space_image" {
  name         = "space_image"
  display_name = "Space Container Image"
  description  = "The container image to use for the space"
  default      = "ghcr.io/cloudnative-coop/iipod:v0.0.13"
  icon         = "https://raw.githubusercontent.com/matifali/logos/main/docker.svg"
  mutable      = true
  type         = "string"
}

data "coder_parameter" "infrasnoop_image" {
  name         = "infrasnoop_image"
  display_name = "Infrasnoop Container Image"
  description  = "The service container image used for infrasnoop / postgresql"
  default      = "ghcr.io/cncf-infra/infrasnoop:2023.05.31-01"
  icon         = "https://raw.githubusercontent.com/matifali/logos/main/docker.svg"
  mutable      = true
  type         = "string"
}

data "coder_parameter" "sideloader_image" {
  name         = "sideloader_image"
  display_name = "Sideloader Container Image"
  description  = "The sidecar container image used to populate recent successful prow jobs"
  default      = "ghcr.io/cncf-infra/infrasnoop-sideloader:2023.05.31-01"
  icon         = "https://raw.githubusercontent.com/matifali/logos/main/docker.svg"
  mutable      = true
  type         = "string"
}

data "coder_parameter" "git_url" {
  name         = "git_url"
  display_name = "Git URL"
  description  = "The Git URL to checkout for this workspace"
  default      = "https://github.com/kubernetes/test-infra"
  mutable      = true
  type         = "string"
  # icon         = "https://raw.githubusercontent.com/matifali/logos/main/docker.svg"
}

data "coder_parameter" "org_url" {
  name         = "org_url"
  display_name = "Orgfile url"
  description  = "The Orgfile URL to load into emacs"
  default      = "https://github.com/cloudnative-coop/coop-templates/raw/canon/infrasnoop/org/ii.org"
  mutable      = true
  type         = "string"
  # icon         = "https://raw.githubusercontent.com/matifali/logos/main/docker.svg"
}
