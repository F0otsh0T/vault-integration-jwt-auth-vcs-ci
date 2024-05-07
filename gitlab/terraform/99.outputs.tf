# 99.outputs.tf

# output "" {
#     value = 
# }

################################################
#  OUTPUTS
################################################

output "random_pet_example_name_0" {
  value = random_pet.example[0].id
}

output "random_pet_example_name_1" {
  value = random_pet.example[1].id
}

output "random_pet_group_name_0" {
  value = random_pet.group[0].id
}

output "random_pet_group_name_1" {
  value = random_pet.group[1].id
}
output "random_uuid_example_result" {
  value = random_uuid.example.result
}

################################################
# VAULT OUTPUTS
################################################

# output "" {
#   value = 
#   description = ""
# }

# output "vault_identity_group_external_id" {
#   value       = vault_identity_group.oidc_provider_azure_group.id
#   description = "Vault Identity Group External ID"
# }

output "vault_jwt_auth_backend_mount_accessor" {
  value       = vault_jwt_auth_backend.jwt_gitlab_id_token.accessor
  description = "Vault Auth JWT GitLab Backend Mount Accessor"
}

# output "mount_accessor" {
#   value       = vault_jwt_auth_backend.oidc_provider_azure.accessor
#   description = "Vault Auth OIDC Backend Mount Accessor"
# }





