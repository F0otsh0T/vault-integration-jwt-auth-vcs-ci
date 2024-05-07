# 01-02.vault.policies.tf

################################################
# VAULT POLICIES
################################################

################################################
# META
# Path Based Policy - GitLab project_path JWT Claim Metadata


# GitLab JWT Custom Claim Metadata
# `project_path`
# Allows Read Access to exact path of Project & Vault secrets
resource "vault_policy" "meta_read_exact" {
  name   = "p.meta.r.exact"
  policy = <<EOF

  path "${vault_mount.gitlab.path}/data/{{identity.entity.aliases.${vault_jwt_auth_backend.jwt_gitlab_id_token.accessor}.metadata.project_path}}" {
    capabilities = ["read"]
  }

  path "${vault_mount.gitlab.path}/metadata/{{identity.entity.aliases.${vault_jwt_auth_backend.jwt_gitlab_id_token.accessor}.metadata.project_path}}" {
    capabilities = ["list"]
  }

  path "sys/policies/acl/*" {
    capabilities = ["read", "list"]
  }

  EOF
}

# GitLab JWT Custom Claim Metadata
# `namespace_path`
# Allows Read Access to all Vault secrets contained in namespace/group
resource "vault_policy" "meta_read_namespace" {
  name   = "p.meta.r.namespace"
  policy = <<EOF

  path "${vault_mount.gitlab.path}/data/{{identity.entity.aliases.${vault_jwt_auth_backend.jwt_gitlab_id_token.accessor}.metadata.namespace_path}}/*" {
    capabilities = ["read"]
  }

  path "${vault_mount.gitlab.path}/metadata/{{identity.entity.aliases.${vault_jwt_auth_backend.jwt_gitlab_id_token.accessor}.metadata.namespace_path}}/*" {
    capabilities = ["list"]
  }

  path "sys/policies/acl/*" {
    capabilities = ["read", "list"]
  }

  EOF
}







# resource "vault_policy" "meta_read_accessors_all" {
#   name   = "p.meta.r.accessors.all"
#   policy = <<EOF

#   path "gitlab/data/{{identity.groups.ids.${vault_identity_group.gitlab_external.id}.metadata.project_path}}" {
#     capabilities = ["read", "list"]
#   }

#   path "gitlab/data/{{identity.groups.ids.${vault_identity_group.gitlab_external.id}.metadata.project_path}}/*" {
#     capabilities = ["read", "list"]
#   }

#   path "gitlab/data/{{identity.entity.aliases.${vault_jwt_auth_backend.jwt_gitlab_id_token.accessor}.metadata.project_path}}" {
#     capabilities = ["read", "list"]
#   }

#   path "gitlab/data/{{identity.entity.aliases.${vault_jwt_auth_backend.jwt_gitlab_id_token.accessor}.metadata.project_path}}/*" {
#     capabilities = ["read", "list"]
#   }

#   path "gitlab/metadata/{{identity.groups.ids.${vault_identity_group.gitlab_external.id}.metadata.project_path}}" {
#     capabilities = ["read", "list"]
#   }

#   path "gitlab/metadata/{{identity.groups.ids.${vault_identity_group.gitlab_external.id}.metadata.project_path}}/*" {
#     capabilities = ["read", "list"]
#   }

#   path "gitlab/metadata/{{identity.entity.aliases.${vault_jwt_auth_backend.jwt_gitlab_id_token.accessor}.metadata.project_path}}" {
#     capabilities = ["read", "list"]
#   }

#   path "gitlab/metadata/{{identity.entity.aliases.${vault_jwt_auth_backend.jwt_gitlab_id_token.accessor}.metadata.project_path}}/*" {
#     capabilities = ["read", "list"]
#   }

#   path "sys/policies/acl/*" {
#     capabilities = ["read", "list"]
#   }

#   EOF
# }