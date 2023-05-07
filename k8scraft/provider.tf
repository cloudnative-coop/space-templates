terraform {
  required_providers {
    # https://registry.terraform.io/providers/coder/coder/latest/docs
    coder = {
      source  = "coder/coder"
      version = "~> 0.7.0" # Current as of May 7th
    }
    # https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.20.0" # Current as of May 7th
    }
  }
}

provider "kubernetes" {
  # If this in run in-cluster, we want kubeconfig = false
  # See https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs#file-config
  config_path = var.use_kubeconfig == false
  # Maybe we should use https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs#in-cluster-config ?
}

# https://developer.hashicorp.com/terraform/language/values/variables#declaring-an-input-variable
variable "namespace" {
  type        = string
  sensitive   = true
  description = "The namespace to create workspaces in (must exist prior to creating workspaces)"
  default     = "coder"
}

# https://registry.terraform.io/providers/coder/coder/latest/docs/data-sources/provisioner#schema
data "coder_provisioner" "ii" {
}

# https://registry.terraform.io/providers/coder/coder/latest/docs/data-sources/workspace#schema
data "coder_workspace" "ii" {
}

# https://developer.hashicorp.com/terraform/language/values/locals
locals {
  username = data.coder_workspace.ii.owner
}
