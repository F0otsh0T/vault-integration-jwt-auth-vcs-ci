---
title: HashiCorp Vault JWT/OIDC Auth and GitLab Paths Integration
description: Integration between HashiCorp Vault and GitLab utilizing JWT/OIDC Auth and Policy ACL Templating to match GitLab Project Paths to KVv2 Mounts
---

# HashiCorp Vault JWT/OIDC Auth and GitLab Paths Integration

---

## REQUIREMENTS
#### GITLAB
- GitLab SaaS / CE / Enterprise
- GitLab Namespace or Parent Group

#### VAULT
- [HashiCorp Vault](https://www.hashicorp.com/products/vault) & [Vault CLI](https://developer.hashicorp.com/vault/tutorials/getting-started/getting-started-install)
- [HashiCorp Terraform](https://developer.hashicorp.com/terraform/install)

## OVERVIEW

 This excercise maps GitLab Project(s)' access to corresponding HashiCorp Vault KVv2 secrets utilizing Policy ACL Templates keying off of **[metadata claims passed](https://developer.hashicorp.com/vault/docs/auth/jwt#claims-as-metadata)** in the JWT Token (**[`project_path` and/or `namespace_path`](https://docs.gitlab.com/ee/ci/secrets/id_token_authentication.html)**) between GitLab and Vault during Authentication.

[![HashiCorp Vault Authentication - OIDC Provider for Azure Active Directory](../assets/vault.auth_jwt-gitlab_project_paths.01.png)](https://developer.hashicorp.com/vault/docs/auth/jwt#claims-as-metadata)

#### HIGH LEVEL STEPS
- Structure GitLab Namespace/Group/Subgroups/Projects and Vault KV Paths in a correspondingly matched fashion
  - See **[APPENDIX A](#appendix-a-path-structure)** for GitLab Group/SubGroups/Projects and Vault Secret Mount path structures used in this excercise
  - GitLab: Namespace / Parent Group here is `dadgarcorp` - substitute this with your own Parent Group / Namespace as needed for your testing or environment.  You will need this and the Namespace ID as inputs.
  - **Note**: [On GitLab SaaS, you must use the GitLab UI to create groups without a parent group. You cannot use the API to do this.](https://docs.gitlab.com/ee/api/groups.html#new-group) Essentially, this is your Namespace or Parent Group.
    - `gitlab_namespace_name` and `gitlab_namespace_id` should be harvested from this action
  - Set `VAULT_ADDR` in GitLab Namespace Settings for CI/CD Variables so your Pipelines and Jobs know how to reach your Vault Cluster.
- Set up Vault JWT/OIDC Authentication for your GitLab infrastructure
- Set up Vault Policy utilizing metadata (in this case, `project_path`) via ACL Templates
  - We will be utilizing the [`{{identity.entity.aliases.<mount accessor>.metadata.<metadata key>}}`](https://developer.hashicorp.com/vault/tutorials/policies/policy-templating#create-templated-acl-policies) Template ACL Policy `{{parameter}}`.
  - Example Policy snippet @ **[`terraform/03-02.02.vault.policy-path.tf`](terraform/03-02.02.vault.policy-path.tf)**:
    ```
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
    ```
- Drop [`ci/.gitlab-ci.yml`](ci/.gitlab-ci.yml) into your Project and `add`/`commit`/`push` to your repo.
- Verify job `read_secrets_path` pulls secret from corresponding Vault KVv2 Secret mount path as your GitLab Project CI

---

#### INPUTS
- `VAULT_ADDR`
- `VAULT_TOKEN`
- `VAULT_NAMESPACE`
- `GITLAB_TOKEN` / `gitlab_token` / [GitLab Group Access Token](https://docs.gitlab.com/ee/user/group/settings/group_access_tokens.html)
- `GITLAB_BASE_URL` (https://gitlab.com/api/v4/)
- `gitlab_namespace_id`
- `gitlab_namespace_name`

---

## REPO STRUCTURE

```
.
├── README.md
├── ci
│   └── .gitlab-ci.yml
└── terraform
    ├── 00-main.tf
    ├── 00-resources.tf
    ├── 00-variables.tf
    ├── 01-01.random.tf
    ├── 02-01.gitlab.groups.tf
    ├── 02-02.gitlab.projects.tf
    ├── 03-01.vault.secrets.tf
    ├── 03-02.01.vault.policy-env.tf
    ├── 03-02.02.vault.policy-path.tf
    ├── 03-03.vault.auth_jwt.tf
    ├── 99.outputs.tf
    ├── templates
    │   ├── p.dev.r.tpl
    │   └── p.prod.r.tpl
    └── terraform.auto.tfvars
```

---

## TLDR;
- Change directory to **[`terraform`](terraform)** directory
- Set up your prerequisite requirements and inputs for Vault and Gitlab
- Run `terraform init` and `terraform apply`
- Drop [`ci/.gitlab-ci.yml`](ci/.gitlab-ci.yml) into your Project and `add`/`commit`/`push` to your repo.
- Verify job `read_secrets_path` pulls secret from corresponding Vault KVv2 Secret mount path as your GitLab Project CI

#### Example GitLab CI Job `read_secrets_path` Output

```
Running with gitlab-runner 16.11.0~pre.21.gaa21be2d (aa21be2d)
  on blue-6.saas-linux-small-amd64.runners-manager.gitlab.com/default nN8vMRS9Z, system ID: s_a899fcd611a3
  feature flags: FF_USE_IMPROVED_URL_MASKING:true
Preparing the "docker+machine" executor
00:10
Using Docker executor with image hashicorp/vault:latest ...
Pulling docker image hashicorp/vault:latest ...
Using docker image sha256:4637322562e8dcdb49cf08a6914dc03e25a890808daf48ad5599bd3c4ef20ee9 for hashicorp/vault:latest with digest hashicorp/vault@sha256:e139ff28c23e1f22a6e325696318141259b177097d8e238a3a4c5b84862fadd8 ...
Preparing environment
00:04
Running on runner-nn8vmrs9z-project-57062898-concurrent-0 via runner-nn8vmrs9z-s-l-s-amd64-1714106045-4b25cace...
Getting source from Git repository
00:01
Fetching changes with git depth set to 20...
Initialized empty Git repository in /builds/dadgarcorp/subgroup-intent-jawfish/subgroup-a-a/project-a-a/.git/
Created fresh repository.
Checking out 4e815310 as detached HEAD (ref is main)...
Skipping Git submodules setup
$ git remote set-url origin "${CI_REPOSITORY_URL}"
Executing "step_script" stage of the job script
00:01
Using docker image sha256:4637322562e8dcdb49cf08a6914dc03e25a890808daf48ad5599bd3c4ef20ee9 for hashicorp/vault:latest with digest hashicorp/vault@sha256:e139ff28c23e1f22a6e325696318141259b177097d8e238a3a4c5b84862fadd8 ...
$ echo -e "ID_TOKEN_1:" $ID_TOKEN_1
ID_TOKEN_1: [MASKED]
$ echo -e "CI_REPOSITORY_URL:" $CI_REPOSITORY_URL
CI_REPOSITORY_URL: https://gitlab-ci-token:[MASKED]@gitlab.com/dadgarcorp/subgroup-intent-jawfish/subgroup-a-a/project-a-a.git
$ echo -e "CI_COMMIT_REF_NAME:" $CI_COMMIT_REF_NAME
CI_COMMIT_REF_NAME: main
$ echo -e "CI_COMMIT_REF_PROTECTED:" $CI_COMMIT_REF_PROTECTED
CI_COMMIT_REF_PROTECTED: true
$ export VAULT_NAMESPACE=admin
$ echo -e "CI_PROJECT_PATH:" $CI_PROJECT_PATH
CI_PROJECT_PATH: dadgarcorp/subgroup-intent-jawfish/subgroup-a-a/project-a-a
$ export VAULT_TOKEN="$(vault write -field=token auth/jwt-gitlab-id-token/login role=role-meta jwt=$ID_TOKEN_1)"
$ export PASSWORD="$(vault kv get -field=password gitlab/$CI_PROJECT_PATH)"
$ echo -e "VAULT SECRET at SECRET_MOUNT/CI_PROJECT_PATH:" $PASSWORD
VAULT SECRET at SECRET_MOUNT/CI_PROJECT_PATH: intent-jawfish/subgroup-a-a/project-a-a-password
Cleaning up project directory and file based variables
00:00
Job succeeded
```
In the above output, `intent-jawfish/subgroup-a-a/project-a-a-password` is the secret retrieved.

---

## TERRAFORM

#### Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13 |
| <a name="requirement_gitlab"></a> [gitlab](#requirement\_gitlab) | >=16.10.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >=3.6.0 |
| <a name="requirement_vault"></a> [vault](#requirement\_vault) | >= 4.1.0 |

#### Providers

| Name | Version |
|------|---------|
| <a name="provider_gitlab"></a> [gitlab](#provider\_gitlab) | 16.10.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.6.0 |
| <a name="provider_vault"></a> [vault](#provider\_vault) | 4.2.0 |

#### Modules

No modules.

#### Resources

| Name | Type |
|------|------|
| [gitlab_group.subgroup_a](https://registry.terraform.io/providers/gitlabhq/gitlab/latest/docs/resources/group) | resource |
| [gitlab_group.subgroup_a_a](https://registry.terraform.io/providers/gitlabhq/gitlab/latest/docs/resources/group) | resource |
| [gitlab_group.subgroup_a_a_a](https://registry.terraform.io/providers/gitlabhq/gitlab/latest/docs/resources/group) | resource |
| [gitlab_group.subgroup_b](https://registry.terraform.io/providers/gitlabhq/gitlab/latest/docs/resources/group) | resource |
| [gitlab_group.subgroup_b_0](https://registry.terraform.io/providers/gitlabhq/gitlab/latest/docs/resources/group) | resource |
| [gitlab_group.subgroup_b_0_0](https://registry.terraform.io/providers/gitlabhq/gitlab/latest/docs/resources/group) | resource |
| [gitlab_group.subgroup_b_0_1](https://registry.terraform.io/providers/gitlabhq/gitlab/latest/docs/resources/group) | resource |
| [gitlab_group.subgroup_b_0_1_0](https://registry.terraform.io/providers/gitlabhq/gitlab/latest/docs/resources/group) | resource |
| [gitlab_group.subgroup_b_0_1_1](https://registry.terraform.io/providers/gitlabhq/gitlab/latest/docs/resources/group) | resource |
| [gitlab_group.subgroup_b_0_1_2](https://registry.terraform.io/providers/gitlabhq/gitlab/latest/docs/resources/group) | resource |
| [gitlab_group.subgroup_b_0_1_2_0](https://registry.terraform.io/providers/gitlabhq/gitlab/latest/docs/resources/group) | resource |
| [gitlab_group.subgroup_b_0_1_2_1](https://registry.terraform.io/providers/gitlabhq/gitlab/latest/docs/resources/group) | resource |
| [gitlab_group.subgroup_b_0_1_2_2](https://registry.terraform.io/providers/gitlabhq/gitlab/latest/docs/resources/group) | resource |
| [gitlab_group.subgroup_b_0_1_2_3](https://registry.terraform.io/providers/gitlabhq/gitlab/latest/docs/resources/group) | resource |
| [gitlab_group.subgroup_b_1](https://registry.terraform.io/providers/gitlabhq/gitlab/latest/docs/resources/group) | resource |
| [gitlab_project.dadgarcorp_alice](https://registry.terraform.io/providers/gitlabhq/gitlab/latest/docs/resources/project) | resource |
| [gitlab_project.project_a](https://registry.terraform.io/providers/gitlabhq/gitlab/latest/docs/resources/project) | resource |
| [gitlab_project.project_a_a](https://registry.terraform.io/providers/gitlabhq/gitlab/latest/docs/resources/project) | resource |
| [gitlab_project.project_a_a_a](https://registry.terraform.io/providers/gitlabhq/gitlab/latest/docs/resources/project) | resource |
| [gitlab_project.project_b](https://registry.terraform.io/providers/gitlabhq/gitlab/latest/docs/resources/project) | resource |
| [gitlab_project.project_b_0](https://registry.terraform.io/providers/gitlabhq/gitlab/latest/docs/resources/project) | resource |
| [gitlab_project.project_b_0_0](https://registry.terraform.io/providers/gitlabhq/gitlab/latest/docs/resources/project) | resource |
| [gitlab_project.project_b_0_1](https://registry.terraform.io/providers/gitlabhq/gitlab/latest/docs/resources/project) | resource |
| [gitlab_project.project_b_0_1_0](https://registry.terraform.io/providers/gitlabhq/gitlab/latest/docs/resources/project) | resource |
| [gitlab_project.project_b_0_1_1](https://registry.terraform.io/providers/gitlabhq/gitlab/latest/docs/resources/project) | resource |
| [gitlab_project.project_b_0_1_2](https://registry.terraform.io/providers/gitlabhq/gitlab/latest/docs/resources/project) | resource |
| [gitlab_project.project_b_0_1_2_0](https://registry.terraform.io/providers/gitlabhq/gitlab/latest/docs/resources/project) | resource |
| [gitlab_project.project_b_0_1_2_1](https://registry.terraform.io/providers/gitlabhq/gitlab/latest/docs/resources/project) | resource |
| [gitlab_project.project_b_0_1_2_2](https://registry.terraform.io/providers/gitlabhq/gitlab/latest/docs/resources/project) | resource |
| [gitlab_project.project_b_0_1_2_3](https://registry.terraform.io/providers/gitlabhq/gitlab/latest/docs/resources/project) | resource |
| [gitlab_project.project_b_1](https://registry.terraform.io/providers/gitlabhq/gitlab/latest/docs/resources/project) | resource |
| [random_id.example](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |
| [random_pet.example](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/pet) | resource |
| [random_pet.group](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/pet) | resource |
| [random_uuid.apps](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/uuid) | resource |
| [random_uuid.example](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/uuid) | resource |
| [vault_jwt_auth_backend.jwt_gitlab](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/jwt_auth_backend) | resource |
| [vault_jwt_auth_backend.jwt_gitlab_id_token](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/jwt_auth_backend) | resource |
| [vault_jwt_auth_backend_role.dev_role](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/jwt_auth_backend_role) | resource |
| [vault_jwt_auth_backend_role.dev_role_id_token](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/jwt_auth_backend_role) | resource |
| [vault_jwt_auth_backend_role.prod_role](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/jwt_auth_backend_role) | resource |
| [vault_jwt_auth_backend_role.prod_role_id_token](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/jwt_auth_backend_role) | resource |
| [vault_jwt_auth_backend_role.role_meta](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/jwt_auth_backend_role) | resource |
| [vault_jwt_auth_backend_role.role_meta_namespace](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/jwt_auth_backend_role) | resource |
| [vault_kv_secret_v2.dadgarcorp-dev](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/kv_secret_v2) | resource |
| [vault_kv_secret_v2.dadgarcorp-prod](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/kv_secret_v2) | resource |
| [vault_kv_secret_v2.dadgarcorp-project-a](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/kv_secret_v2) | resource |
| [vault_kv_secret_v2.dadgarcorp-project-a-a](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/kv_secret_v2) | resource |
| [vault_kv_secret_v2.dadgarcorp-project-a-a-a](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/kv_secret_v2) | resource |
| [vault_kv_secret_v2.dadgarcorp-project-a-a-folder](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/kv_secret_v2) | resource |
| [vault_kv_secret_v2.dadgarcorp-project-b](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/kv_secret_v2) | resource |
| [vault_kv_secret_v2.dadgarcorp-project-b-0](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/kv_secret_v2) | resource |
| [vault_kv_secret_v2.dadgarcorp-project-b-0-0](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/kv_secret_v2) | resource |
| [vault_kv_secret_v2.dadgarcorp-project-b-0-1](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/kv_secret_v2) | resource |
| [vault_kv_secret_v2.dadgarcorp-project-b-0-1-0](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/kv_secret_v2) | resource |
| [vault_kv_secret_v2.dadgarcorp-project-b-0-1-1](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/kv_secret_v2) | resource |
| [vault_kv_secret_v2.dadgarcorp-project-b-0-1-2](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/kv_secret_v2) | resource |
| [vault_kv_secret_v2.dadgarcorp-project-b-0-1-2-0](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/kv_secret_v2) | resource |
| [vault_kv_secret_v2.dadgarcorp-project-b-0-1-2-1](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/kv_secret_v2) | resource |
| [vault_kv_secret_v2.dadgarcorp-project-b-0-1-2-2](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/kv_secret_v2) | resource |
| [vault_kv_secret_v2.dadgarcorp-project-b-0-1-2-3](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/kv_secret_v2) | resource |
| [vault_kv_secret_v2.dadgarcorp-project-b-1](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/kv_secret_v2) | resource |
| [vault_kv_secret_v2.dadgarcorp-subgroup-a](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/kv_secret_v2) | resource |
| [vault_kv_secret_v2.dadgarcorp-subgroup-a-a](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/kv_secret_v2) | resource |
| [vault_kv_secret_v2.dadgarcorp-subgroup-a-a-a](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/kv_secret_v2) | resource |
| [vault_kv_secret_v2.dadgarcorp-subgroup-b](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/kv_secret_v2) | resource |
| [vault_kv_secret_v2.dadgarcorp-subgroup-b-0](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/kv_secret_v2) | resource |
| [vault_kv_secret_v2.dadgarcorp-subgroup-b-0-0](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/kv_secret_v2) | resource |
| [vault_kv_secret_v2.dadgarcorp-subgroup-b-0-1](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/kv_secret_v2) | resource |
| [vault_kv_secret_v2.dadgarcorp-subgroup-b-0-1-0](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/kv_secret_v2) | resource |
| [vault_kv_secret_v2.dadgarcorp-subgroup-b-0-1-1](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/kv_secret_v2) | resource |
| [vault_kv_secret_v2.dadgarcorp-subgroup-b-0-1-2](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/kv_secret_v2) | resource |
| [vault_kv_secret_v2.dadgarcorp-subgroup-b-0-1-2-0](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/kv_secret_v2) | resource |
| [vault_kv_secret_v2.dadgarcorp-subgroup-b-0-1-2-1](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/kv_secret_v2) | resource |
| [vault_kv_secret_v2.dadgarcorp-subgroup-b-0-1-2-2](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/kv_secret_v2) | resource |
| [vault_kv_secret_v2.dadgarcorp-subgroup-b-0-1-2-3](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/kv_secret_v2) | resource |
| [vault_kv_secret_v2.dadgarcorp-subgroup-b-1](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/kv_secret_v2) | resource |
| [vault_kv_secret_v2.dadgarcorp_secret](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/kv_secret_v2) | resource |
| [vault_mount.dadgarcorp](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/mount) | resource |
| [vault_mount.gitlab](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/mount) | resource |
| [vault_policy.dev_read](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/policy) | resource |
| [vault_policy.meta_read_exact](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/policy) | resource |
| [vault_policy.meta_read_namespace](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/policy) | resource |
| [vault_policy.prod_read](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/policy) | resource |

#### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_gitlab_namespace_id"></a> [gitlab\_namespace\_id](#input\_gitlab\_namespace\_id) | GitLab Namespace ID - Parent Group ID | `string` | `"012345679"` | no |
| <a name="input_gitlab_namespace_name"></a> [gitlab\_namespace\_name](#input\_gitlab\_namespace\_name) | GitLab Namespace Name - Parent Group Name | `string` | `"blabblahblah"` | no |
| <a name="input_gitlab_token"></a> [gitlab\_token](#input\_gitlab\_token) | GitLab Personal Access Token | `string` | `""` | no |
| <a name="input_gitlab_url"></a> [gitlab\_url](#input\_gitlab\_url) | GitLab Base URL | `string` | `"https://gitlab.com"` | no |
| <a name="input_pet_name"></a> [pet\_name](#input\_pet\_name) | Pet Name | `string` | `"pet"` | no |
| <a name="input_user"></a> [user](#input\_user) | Demo User | `string` | `"user"` | no |
| <a name="input_uuid"></a> [uuid](#input\_uuid) | UUID | `string` | `"00000000-0000-0000-0000-000000000"` | no |
| <a name="input_vault_auth_mount_path_ci_job"></a> [vault\_auth\_mount\_path\_ci\_job](#input\_vault\_auth\_mount\_path\_ci\_job) | Vault Authentication Mount Path | `string` | `"jwt-gitlab"` | no |
| <a name="input_vault_auth_mount_path_id_token"></a> [vault\_auth\_mount\_path\_id\_token](#input\_vault\_auth\_mount\_path\_id\_token) | Vault Authentication Mount Path | `string` | `"jwt-gitlab-id-token"` | no |
| <a name="input_vault_cli_port"></a> [vault\_cli\_port](#input\_vault\_cli\_port) | Vault CLI Port | `string` | `"8250"` | no |
| <a name="input_vault_port"></a> [vault\_port](#input\_vault\_port) | Vault Port | `string` | `"8200"` | no |
| <a name="input_vault_root_token"></a> [vault\_root\_token](#input\_vault\_root\_token) | Vault Root Token | `string` | `""` | no |
| <a name="input_vault_url"></a> [vault\_url](#input\_vault\_url) | Vault URL | `string` | `"http://localhost:8200"` | no |

#### Outputs

| Name | Description |
|------|-------------|
| <a name="output_random_pet_example_name_0"></a> [random\_pet\_example\_name\_0](#output\_random\_pet\_example\_name\_0) | n/a |
| <a name="output_random_pet_example_name_1"></a> [random\_pet\_example\_name\_1](#output\_random\_pet\_example\_name\_1) | n/a |
| <a name="output_random_pet_group_name_0"></a> [random\_pet\_group\_name\_0](#output\_random\_pet\_group\_name\_0) | n/a |
| <a name="output_random_pet_group_name_1"></a> [random\_pet\_group\_name\_1](#output\_random\_pet\_group\_name\_1) | n/a |
| <a name="output_random_uuid_example_result"></a> [random\_uuid\_example\_result](#output\_random\_uuid\_example\_result) | n/a |
| <a name="output_vault_jwt_auth_backend_mount_accessor"></a> [vault\_jwt\_auth\_backend\_mount\_accessor](#output\_vault\_jwt\_auth\_backend\_mount\_accessor) | Vault Auth JWT GitLab Backend Mount Accessor |



---
## APPENDIX A: PATH STRUCTURE

#### Vault Secret: KVv2

`gitlab` is the Vault KVv2 Secrets Mount

###### Key:
  - 🖹 == Secret
  - 📁 == Mount Path

```
.
└── 📁 gitlab
    ├── 🖹 dadgarcorp
    └── 📁 dadgarcorp
        ├── 🖹 subgroup-{{random_pet[0]}}
        ├── 📁 subgroup-{{random_pet[0]}}
        │   ├── 🖹 project-{{random_pet[0]}}
        │   ├── 🖹 subgroup-a-a
        │   └── 📁 subgroup-a-a
        │       ├── 🖹 project-a-a
        │       ├── 🖹 subgroup-a-a-a
        │       └── 📁 subgroup-a-a-a
        │           └── 🖹 project-a-a-a
        ├── 🖹 subgroup-{{random_pet[1]}}
        └── 📁 subgroup-{{random_pet[1]}}
            ├── 🖹 project-{{random_pet[1]}}
            ├── 🖹 subgroup-b-0
            ├── 📁 subgroup-b-0
            │   ├── 🖹 project-b-0
            │   ├── 🖹 subgroup-b-0-0
            │   ├── 📁 subgroup-b-0-0
            │   │   └── 🖹 project-b-0-0
            │   ├── 🖹 subgroup-b-0-1
            │   └── 📁 subgroup-b-0-1
            │       ├── 🖹 project-b-0-1
            │       ├── 🖹 subgroup-b-0-1-0
            │       ├── 📁 subgroup-b-0-1-0
            │       │   └── 🖹 project-b-0-1-0
            │       ├── 🖹 subgroup-b-0-1-1
            │       ├── 📁 subgroup-b-0-1-1
            │       │   └── 🖹 project-b-0-1-1
            │       ├── 🖹 subgroup-b-0-1-2
            │       └── 📁 subgroup-b-0-1-2
            │           ├── 🖹 project-b-0-1-2
            │           ├── 🖹 subgroup-b-0-1-2-0
            │           ├── 📁 subgroup-b-0-1-2-0
            │           │   └── 🖹 project-b-0-1-2-0
            │           ├── 🖹 subgroup-b-0-1-2-1
            │           ├── 📁 subgroup-b-0-1-2-1
            │           │   └── 🖹 project-b-0-1-2-1
            │           ├── 🖹 subgroup-b-0-1-2-2
            │           ├── 📁 subgroup-b-0-1-2-2
            │           │   └── 🖹 project-b-0-1-2-2
            │           ├── 🖹 subgroup-b-0-1-2-3
            │           └── 📁 subgroup-b-0-1-2-3
            │               └── 🖹 project-b-0-1-2-3
            ├── 🖹 subgroup-b-1
            └── 📁 subgroup-b-1
                └── 🖹 project-b-1
```
#### GitLab: NameSpace  (Parent Group) / SubGroups and Projects (Repos)

###### Key:
  - 📁 == NameSpace (Parent Group) / SubGroup
  - 🖹 == Project (Repo)

```
.
└── 📁 dadgarcorp
    ├── 📁 subgroup-{{random_pet[0]}}
    │   ├── 🖹 project-{{random_pet[0]}}
    │   └── 📁 subgroup-a-a
    │       ├── 🖹 project-a-a
    │       └── 📁 subgroup-a-a-a
    │           └── 🖹 project-a-a-a
    └── 📁 subgroup-{{random_pet[1]}}
        ├── 🖹 project-{{random_pet[1]}}
        ├── 📁 subgroup-b-0
        │   ├── 🖹 project-b-0
        │   ├── 📁 subgroup-b-0-0
        │   │   └── 🖹 project-b-0-0
        │   └── 📁 subgroup-b-0-1
        │       ├── 🖹 project-b-0-1
        │       ├── 📁 subgroup-b-0-1-0
        │       │   └── 🖹 project-b-0-1-0
        │       ├── 📁 subgroup-b-0-1-1
        │       │   └── 🖹 project-b-0-1-1
        │       └── 📁 subgroup-b-0-1-2
        │           ├── 🖹 project-b-0-1-2
        │           ├── 📁 subgroup-b-0-1-2-0
        │           │   └──🖹 project-b-0-1-2-0
        │           ├── 📁 subgroup-b-0-1-2-1
        │           │   └──🖹 project-b-0-1-2-1
        │           ├── 📁 subgroup-b-0-1-2-2
        │           │   └──🖹 project-b-0-1-2-2
        │           └── 📁 subgroup-b-0-1-2-3
        │               └──🖹 project-b-0-1-2-3
        └── 📁 subgroup-b-1
            └── 🖹 project-b1
```

---

## APPENDIX B
#### Reference Links
- https://developer.hashicorp.com/vault/docs/auth/jwt#claims-as-metadata
- https://developer.hashicorp.com/vault/docs/concepts/policies
- https://developer.hashicorp.com/vault/docs/concepts/policies#parameters
- https://developer.hashicorp.com/vault/docs/auth/jwt/oidc-providers/gitlab
- https://github.com/jeffsanicola/vault-policy-guide
- https://support.hashicorp.com/hc/en-us/articles/6572815701907-How-to-give-access-to-user-for-specific-path-inside-KV-secret
- 
#### Tutorial Links
- https://developer.hashicorp.com/vault/tutorials/getting-started/getting-started-policies
- https://developer.hashicorp.com/vault/tutorials/policies/policies
- https://developer.hashicorp.com/vault/tutorials/policies/policy-templating
- https://developer.hashicorp.com/vault/tutorials/policies/policy-templating#create-templated-acl-policies
- https://developer.hashicorp.com/vault/tutorials/policies/policy-templating#available-templating-parameters
#### GitLab References
- https://docs.gitlab.com/ee/ci/examples/authenticating-with-hashicorp-vault/
- https://docs.gitlab.com/ee/integration/vault.html
- https://github.com/rgl/gitlab-ci-validate-jwt/blob/master/README.md
- https://docs.gitlab.com/ee/ci/variables/predefined_variables.html
- https://docs.gitlab.com/ee/ci/variables/
- https://docs.gitlab.com/ee/ci/secrets/id_token_authentication.html
  - `project_path`
- https://docs.gitlab.com/ee/update/deprecations.html#hashicorp-vault-integration-will-no-longer-use-ci_job_jwt-by-default
- 

---

## ISSUES
- JWKS URL is not reachable on GitLab SaaS for some reason.
  - Documented GitLab JWKS URL: https://gitlab.com/-/jwks
  - Alternative: https://gitlab.com/oauth/discovery/keys
  - This is set in [terraform/03-03.vault.auth_jwt.tf](terraform/03-03.vault.auth_jwt.tf)
- https://gitlab.com/gitlab-org/gitlab/-/issues/221031: ~./-/jwks endpoint removed at same time as `CI_JOB_JWT` deprecation.
- See OIDC Discovery endpoint `jwks_uri` value at https://gitlab.com/.well-known/openid-configuration: ***`https://gitlab.com/oauth/discovery/keys`***

---

## ACKNOWLEDGEMENTS

Thank you **[@sofixa](https://github.com/sofixa)** and **[@dgreeninger](https://github.com/dgreeninger)** for your help!