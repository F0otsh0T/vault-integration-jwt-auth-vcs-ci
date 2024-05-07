# 01-03.vault.jwt_auth.tf

################################################
# [DEPRECATED] OLD GITLAB JWT/OIDC METHOD

resource "vault_jwt_auth_backend" "jwt_gitlab" {
  depends_on = [

  ]
  description = "JWT/OIDC Auth Backend for GitLab"
  path        = var.vault_auth_mount_path_ci_job
  type        = "jwt"
  #  oidc_discovery_url = "https://gitlab.com/.well-known/openid-configuration"
  #  oidc_discovery_url = "https://gitlab.com"
  # jwks_url     = "https://gitlab.com/-/jwks"
  jwks_url     = "https://gitlab.com/oauth/discovery/keys"
  bound_issuer = "gitlab.com"
  provider_config = {

  }
  # tune {
  #     listing_visibility = "unauth"
  # }
}

# PROD/DEV SECRETS MOUNTS DEMO

resource "vault_jwt_auth_backend_role" "dev_role" {
  backend   = vault_jwt_auth_backend.jwt_gitlab.path
  role_name = "role-dev"
  #  user_claim           = "oid"
  user_claim             = "user_email"
  bound_claims_type      = "glob"
  role_type              = "jwt"
  verbose_oidc_logging   = true
  token_explicit_max_ttl = "300"
  bound_claims = {
    environment = "dev",
    ref         = "main,develop,test,auto-deploy-*",
    ref_type    = "branch"
  }
  token_policies = [
    "p.dev.r"
  ]
}

resource "vault_jwt_auth_backend_role" "prod_role" {
  backend   = vault_jwt_auth_backend.jwt_gitlab.path
  role_name = "role-prod"
  #  user_claim           = "oid"
  user_claim             = "user_email"
  bound_claims_type      = "glob"
  role_type              = "jwt"
  verbose_oidc_logging   = true
  token_explicit_max_ttl = "60"
  bound_claims = {
    environment = "prod",
    ref         = "main,develop,test,auto-deploy-*",
    ref_type    = "branch"
  }
  token_policies = [
    "p.prod.r"
  ]
}

################################################
# [VALID] NEW GITLAB JWT/OIDC METHOD - ID_TOKEN

resource "vault_jwt_auth_backend" "jwt_gitlab_id_token" {
  depends_on = [

  ]
  description = "JWT/OIDC Auth Backend for GitLab"
  path        = var.vault_auth_mount_path_id_token
  type        = "jwt"
  #  oidc_discovery_url = "https://gitlab.com/.well-known/openid-configuration"
  #  oidc_discovery_url = "https://gitlab.com"
  # jwks_url     = "https://gitlab.com/-/jwks"
  jwks_url     = "https://gitlab.com/oauth/discovery/keys"
  bound_issuer = "https://gitlab.com"
  provider_config = {

  }
  # tune {
  #     listing_visibility = "unauth"
  # }
}

# PROD/DEV SECRETS MOUNTS DEMO

resource "vault_jwt_auth_backend_role" "dev_role_id_token" {
  backend   = vault_jwt_auth_backend.jwt_gitlab_id_token.path
  role_name = "role-dev"
  #  user_claim           = "oid"
  user_claim             = "user_email"
  bound_claims_type      = "glob"
  role_type              = "jwt"
  verbose_oidc_logging   = true
  token_explicit_max_ttl = "300"
  bound_claims = {
    environment = "dev",
    ref         = "main,develop,test,auto-deploy-*",
    ref_type    = "branch"
  }
  token_policies = [
    "p.dev.r"
  ]
}

resource "vault_jwt_auth_backend_role" "prod_role_id_token" {
  backend   = vault_jwt_auth_backend.jwt_gitlab_id_token.path
  role_name = "role-prod"
  #  user_claim           = "oid"
  user_claim             = "user_email"
  bound_claims_type      = "glob"
  role_type              = "jwt"
  verbose_oidc_logging   = true
  token_explicit_max_ttl = "60"
  bound_claims = {
    environment = "prod",
    ref         = "main,develop,test,auto-deploy-*",
    ref_type    = "branch"
  }
  token_policies = [
    "p.prod.r"
  ]
}

## METADATA DEMO - CLAIM_MAPPINGS: GITLAB "project_path"

resource "vault_jwt_auth_backend_role" "role_meta" {
  backend   = vault_jwt_auth_backend.jwt_gitlab_id_token.path
  role_name = "role-meta"
  #  user_claim           = "oid"
  # user_claim             = "user_email"
  user_claim             = "project_path"
  bound_claims_type      = "glob"
  role_type              = "jwt"
  verbose_oidc_logging   = true
  token_explicit_max_ttl = "60"
  bound_claims = {
    # project_path = "",
    project_path = "${var.gitlab_namespace_name}/*",
    ref      = "main,develop,test,auto-deploy-*",
    ref_type = "branch"
  }
  token_policies = [
    "p.meta.r.exact"
  ]
  claim_mappings = {
    project_path = "project_path",
    namespace_path = "namespace_path"
  }
}

## METADATA DEMO - CLAIM_MAPPINGS: GITLAB "namespace_path"

resource "vault_jwt_auth_backend_role" "role_meta_namespace" {
  backend   = vault_jwt_auth_backend.jwt_gitlab_id_token.path
  role_name = "role-meta-namespace"
  #  user_claim           = "oid"
  # user_claim             = "user_email"
  user_claim             = "project_path"
  bound_claims_type      = "glob"
  role_type              = "jwt"
  verbose_oidc_logging   = true
  token_explicit_max_ttl = "60"
  bound_claims = {
    # project_path = "",
    project_path = "${var.gitlab_namespace_name}/*",
    ref      = "main,develop,test,auto-deploy-*",
    ref_type = "branch"
  }
  token_policies = [
    "p.meta.r.namespace"
  ]
  claim_mappings = {
    project_path = "project_path",
    namespace_path = "namespace_path"
  }
}


# resource "vault_identity_group" "gitlab_external" {
#   name        = "group_gitlab_external"
#   type        = "external"
#   policies    = [
#     "p.meta.r.exact"
#   ]
#   metadata = {
#     project_path = "project_path",
#     namespace_path = "namespace_path"
#   }
# }

# resource "vault_identity_group_alias" "gitlab_external_alias" {
#   name     = "group_alias_gitlab_external"
#   mount_accessor = vault_jwt_auth_backend.jwt_gitlab_id_token.accessor
#   canonical_id = vault_identity_group.gitlab_external.id
# }
