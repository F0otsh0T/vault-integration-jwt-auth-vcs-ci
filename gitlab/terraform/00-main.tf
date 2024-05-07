# 00.versions.tf

terraform {
  required_version = ">= 0.13"
  required_providers {
    vault = {
      source  = "hashicorp/vault"
      version = ">= 4.1.0"
    }
    gitlab = {
      source  = "gitlabhq/gitlab"
      version = ">=16.10.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">=3.6.0"
    }
  }
}

# locals {
#   vault_root_token  = var.vault_root_token
#   vault_url         = var.vault_url
#   vault_port        = var.vault_port
#   vault_cli_port    = var.vault_cli_port
# }

provider "vault" {
  # Configuration options
  ## export VAULT_ADDR="http://localhost:8200"
  # address = var.vault_url
  #  address = "${var.vault_url}:${var.vault_port}"
  ## export VAULT_TOKEN="your-root-token"
  #  token   = var.vault_root_token
  #  skip_child_token = true
}

provider "gitlab" {
  # Configuration options
  ## export GITLAB_BASE_URL="https://gitlab.com"
  # base_url = var.gitlab_url
  ## export GITLAB_TOKEN="your-personal-access-token"
  # token    = var.gitlab_token
}

provider "random" {
  # Configuration options
}
