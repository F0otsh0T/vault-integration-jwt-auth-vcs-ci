---
title: [Vault Integration] JWT/OIDC Auth <=> VCS and CI
description: Integrating HashiCorp Vault with VCS an CI Platforms
---

# Gitlab JWT => ID_TOKEN

## Background

Breaking change in Gitlab 16.0 (2023-05-22) documented here:
https://docs.gitlab.com/ee/update/deprecations.html#hashicorp-vault-integration-will-no-longer-use-ci_job_jwt-by-default

> Planned removal: GitLab 16.0 (2023-05-22)
>
> As part of our effort to improve the security of your CI workflows using JWT and OIDC, the native HashiCorp integration is also being updated in GitLab 16.0. Any projects that use the `secrets:vault` keyword to retrieve secrets from Vault will need to be [configured to use ID tokens](https://docs.gitlab.com/ee/ci/secrets/id_token_authentication.html#configure-automatic-id-token-authentication).
>
>To be prepared for this change, you should do the following before GitLab 16.0:
>
>Disable the use of JSON web tokens in the pipeline.
Ensure the bound audience is prefixed with `https://`.
Use the new `id_tokens` keyword and configure the `aud` claim.


## Changes Needed
#### Gitlab
- Gitlab Project => Settings => CICD => Token Access (Expand)
  - [Toggle Limit JSON Web Token (JWT) access to enabled](https://docs.gitlab.com/ee/ci/secrets/id_token_authentication.html#enable-automatic-id-tokena-authentication).
  - Implications:
    - JWT Variables `$CI_JOB_JWT` and `$CI_JOB_JWT_V2` no longer rendered to Pipeline Job(s)
    - [Configure automatic `id_token` Authentication](https://docs.gitlab.com/ee/ci/secrets/id_token_authentication.html#configure-automatic-id-token-authentication)
    - `id_token` property `aud` value should match Vault JWT Auth Role `bound_audiences` value

#### Vault
- Vault JWT Auth Configuration
  - Verify `https://` prepended to `bound_issue` value
  - Vault UI: Access => JWT Auth => Configure => JWT Options => "Bound issuer"
  - CLI Example:
    - ```shell
        vault write auth/jwt-gitlab-id-token/config \
        jwks_url="https://gitlab.com/-/jwks" \
        bound_issuer="https://gitlab.com"
        ```
- Vault JWT Auth Role
  - Add `bound_audiences` value to Vault JWT Auth Role
  - CLI Example:
    - ```shell
        vault write auth/jwt-gitlab-id-token/role/role-prod - <<EOF
        {
        "role_type": "jwt",
        "policies": ["p.prod.r"],
        "token_explicit_max_ttl": 60,
        "user_claim": "user_email",
        "bound_audiences": "https://gitlab.com",
        "bound_claims_type": "glob",
        "bound_claims": {
            "environment": "prod",
            "ref": ["main", "develop", "test", "auto-deploy-*"],
            "ref_type": "branch"
          }
        }
        EOF
        ```
  - ***NOTE***: If Gitlab Settings and Vault were already configured for Gitlab `$CI_JOB_JWT_V2` JWT Tokens, the above Vault changes should have already been changed as `id_tokens` utilizes the same JWT Auth `bound_issuer` and JWT Auth Role `bound_audiences` values documented above.



## REFERENCES
- https://docs.gitlab.com/ee/update/deprecations.html#hashicorp-vault-integration-will-no-longer-use-ci_job_jwt-by-default
- https://docs.gitlab.com/ee/ci/yaml/index.html#id_tokens
- https://docs.gitlab.com/ee/ci/secrets/id_token_authentication.html
- https://gitlab.com/gitlab-org/gitlab/-/issues/357624
- https://youtu.be/NsPcl4rqy9A?t=426
- https://docs.gitlab.com/ee/ci/secrets/
- https://docs.gitlab.com/ee/ci/examples/authenticating-with-hashicorp-vault/
- https://gitlab.com/gitlab-org/gitlab/-/merge_requests/72555
- ***https://docs.gitlab.com/ee/ci/variables/predefined_variables.html#predefined-variables-reference***
  - > A newly formatted RS256 JSON web token to increase compatibility. Similar to CI_JOB_JWT, except the issuer (iss) claim is changed from gitlab.com to https://gitlab.com, sub has changed from job_id to a string that contains the project path, and an aud claim is added. Format is subject to change. Be aware, the aud field is a constant value. Trusting JWTs in multiple relying parties can lead to one RP sending a JWT to another one and acting maliciously as a job.
- 



## APPENDIX

- Sample Gitlab Pipeline YML:

    ```yaml

    # READ VAULT SECRETS
    # REF: https://docs.gitlab.com/ee/ci/examples/authenticating-with-hashicorp-vault/

    read_secrets_dev:
    image: vault:latest
    script:
        # Check job's ref name
        - echo $CI_COMMIT_REF_NAME
        # and is this ref protected
        - echo $CI_COMMIT_REF_PROTECTED
        # Check CI_JOB_JWT Token
        - echo $CI_JOB_JWT
        # Check CI_JOB_JWT_V2 Token
        - echo $CI_JOB_JWT_V2
        # Vault Namespace
        - export VAULT_NAMESPACE=admin
        # Vault's address can be provided here or as CI/CD variable
        - export VAULT_ADDR=https://vault-public-vault-39fd5dca.116f54e0.z1.hashicorp.cloud:8200
        # Authenticate and get token. Token expiry time and other properties can be configured
        # when configuring JWT Auth - https://developer.hashicorp.com/vault/api-docs/auth/jwt#parameters-1
        - export VAULT_TOKEN="$(vault write -field=token auth/jwt-gitlab/login role=role-dev jwt=$CI_JOB_JWT)"
        #- export VAULT_TOKEN="$(vault write -field=token auth/jwt-gitlab/login role=role-dev jwt=$CI_JOB_JWT)"
        # Check Vault Token
        #- echo $VAULT_TOKEN
        # Now use the VAULT_TOKEN to read the secret and store it in an environment variable
        - export PASSWORD="$(vault kv get -field=password dadgarcorp/dev/cred)"
        # Use the secret
        - echo $PASSWORD
        # This will fail because the role myproject-staging can not read secrets from secret/myproject/production/*
        - export PASSWORD="$(vault kv get -field=password dadgarcorp/prod/cred)"
        # Use the secret
        - echo $PASSWORD
    environment:
        name: dev


    read_secrets_prod:
    image: vault:latest
    # ID TOKEN
    id_tokens:
        ID_TOKEN_1:
        aud:
    #        - https://vault-public-vault-39fd5dca.116f54e0.z1.hashicorp.cloud:8200
            - https://gitlab.com
    script:
        # CHECK ID_TOKEN
        - echo $ID_TOKEN_1
        # Check job's ref name
        - echo $CI_COMMIT_REF_NAME
        # and is this ref protected
        - echo $CI_COMMIT_REF_PROTECTED
        # Check CI_JOB_JWT Token
        - echo $CI_JOB_JWT
        # Check CI_JOB_JWT_V2 Token
        - echo $CI_JOB_JWT_V2
        # Vault Namespace
        - export VAULT_NAMESPACE=admin
        # Vault's address can be provided here or as CI/CD variable
        - export VAULT_ADDR=https://vault-public-vault-39fd5dca.116f54e0.z1.hashicorp.cloud:8200
        # Authenticate and get token. Token expiry time and other properties can be configured
        # when configuring JWT Auth - https://developer.hashicorp.com/vault/api-docs/auth/jwt#parameters-1
        # - export VAULT_TOKEN="$(vault write -field=token auth/jwt-gitlab/login role=role-dev jwt=$CI_JOB_JWT)"
        - export VAULT_TOKEN="$(vault write -field=token auth/jwt-gitlab-id-token/login role=role-prod jwt=$ID_TOKEN_1)"
        # Check Vault Token
        #- echo $VAULT_TOKEN
        # Now use the VAULT_TOKEN to read the secret and store it in an environment variable
        - export PASSWORD="$(vault kv get -field=password dadgarcorp/dev/cred)"
        # Use the secret
        - echo $PASSWORD
        # This will fail because the role myproject-staging can not read secrets from secret/myproject/production/*
        - export PASSWORD="$(vault kv get -field=password dadgarcorp/prod/cred)"
        # Use the secret
        - echo $PASSWORD
    # secrets:
    #   TEST_SECRET:
    #     vault: dadgarcorp/prod/cred
    environment:
        name: prod
    ```
- Vault Steps for `$CI_JOB_JWT` and Gitlab Pipeline `read_secrets_dev` Job:
    ```shell

    vault secrets enable -version=2 -path=dadgarcorp/dev kv

    vault kv put -mount=dadgarcorp/dev cred password=devpass

    vault kv get dadgarcorp/dev/cred
    vault kv get -field=password dadgarcorp/dev/cred

    vault secrets enable -version=2 -path=dadgarcorp/prod kv

    vault kv put -mount=dadgarcorp/prod cred password=prodpass

    vault kv get dadgarcorp/prod/cred
    vault kv get -field=password dadgarcorp/prod/cred

    vault policy write p.dev.r - <<EOF
    path "dadgarcorp/dev/*" {
        capabilities = [ "read" ]
    }
    EOF

    vault policy write p.prod.r - <<EOF
    path "dadgarcorp/prod/*" {
        capabilities = [ "read" ]
    }
    EOF

    vault auth enable -path=jwt-gitlab jwt

    vault write auth/jwt-gitlab/role/role-dev - <<EOF
    {
    "role_type": "jwt",
    "policies": ["p.dev.r"],
    "token_explicit_max_ttl": 300,
    "user_claim": "user_email",
    "bound_claims_type": "glob",
    "bound_claims": {
        "environment": "dev",
        "ref": ["main", "develop", "test", "auto-deploy-*"],
        "ref_type": "branch"
      }
    }
    EOF

    vault write auth/jwt-gitlab/role/role-prod - <<EOF
    {
    "role_type": "jwt",
    "policies": ["p.prod.r"],
    "token_explicit_max_ttl": 60,
    "user_claim": "user_email",
    "bound_claims_type": "glob",
    "bound_claims": {
        "environment": "prod",
        "ref": ["main", "develop", "test", "auto-deploy-*"],
        "ref_type": "branch"
      }
    }
    EOF

    vault write auth/jwt-gitlab/config \
        jwks_url="https://gitlab.com/-/jwks" \
        bound_issuer="gitlab.com"

    ```
- Vault Steps for `id_token` or `$ID_TOKEN_1` and Gitlab Pipeline `read_secrets_prod` Job:
    ```shell

    vault auth enable -path=jwt-gitlab-id-token jwt

    vault write auth/jwt-gitlab-id-token/role/role-prod - <<EOF
    {
    "role_type": "jwt",
    "policies": ["p.prod.r"],
    "token_explicit_max_ttl": 60,
    "user_claim": "user_email",
    "bound_audiences": "https://gitlab.com",
    "bound_claims_type": "glob",
    "bound_claims": {
        "environment": "prod",
        "ref": ["main", "develop", "test", "auto-deploy-*"],
        "ref_type": "branch"
      }
    }
    EOF

    vault write auth/jwt-gitlab-id-token/config \
        jwks_url="https://gitlab.com/-/jwks" \
        bound_issuer="https://gitlab.com"




    ```