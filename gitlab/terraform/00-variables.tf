# 00.variables.tf

# variable "" {
#     type = string
#     description = ""
#     sensitive = false
#     default = ""
# }

################################################
# DEMO VARIABLES

variable "user" {
  type        = string
  description = "Demo User"
  sensitive   = false
  default     = "user"
}

################################################
# RANDOM VARIABLES

variable "pet_name" {
  type        = string
  description = "Pet Name"
  sensitive   = false
  default     = "pet"
}

variable "uuid" {
  type        = string
  description = "UUID"
  sensitive   = false
  default     = "00000000-0000-0000-0000-000000000"
}

################################################
# VAULT VARIABLES

variable "vault_root_token" {
  type        = string
  description = "Vault Root Token"
  sensitive   = false
  default     = ""
}

variable "vault_url" {
  type        = string
  description = "Vault URL"
  sensitive   = false
  default     = "http://localhost:8200"
}

variable "vault_port" {
  type        = string
  description = "Vault Port"
  sensitive   = false
  default     = "8200"
}

variable "vault_cli_port" {
  type        = string
  description = "Vault CLI Port"
  sensitive   = false
  default     = "8250"
}

variable "vault_auth_mount_path_ci_job" {
  type        = string
  description = "Vault Authentication Mount Path"
  sensitive   = false
  default     = "jwt-gitlab"
}

variable "vault_auth_mount_path_id_token" {
  type        = string
  description = "Vault Authentication Mount Path"
  sensitive   = false
  default     = "jwt-gitlab-id-token"
}

################################################
# GITLAB VARIABLES

# GITLAB_BASE_URL
variable "gitlab_url" {
  type        = string
  description = "GitLab Base URL"
  sensitive   = false
  default     = "https://gitlab.com"
}

# GITLAB_TOKEN
variable "gitlab_token" {
  type        = string
  description = "GitLab Personal Access Token"
  sensitive   = true
  default     = ""
}

# GITLAB NAMESPACE ID: dadgarcorp
variable "gitlab_namespace_id" {
  type        = string
  description = "GitLab Namespace ID - Parent Group ID"
  sensitive   = false
  default     = "012345679"
}

variable "gitlab_namespace_name" {
  type        = string
  description = "GitLab Namespace Name - Parent Group Name"
  sensitive   = false
  default     = "blabblahblah"
}
