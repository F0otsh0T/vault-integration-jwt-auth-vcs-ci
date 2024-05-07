# 01-01.vault.secrets.tf

################################################
# VAULT SECRETS ENGINE: KVv2

resource "vault_mount" "gitlab" {
  type        = "kv"
  description = "KVv2 Secret Engine Mount: GitLab"
  options     = { version = "2" }
  path        = "gitlab"
}

# resource "vault_mount" "dadgarcorp-prod" {
#   type        = "kv"
#   description = "KVv2 Secret Engine Mount: dadgarcorp/prod"
#   options     = { version = "2" }
#   path        = "dadgarcorp/prod"
# }

resource "vault_kv_secret_v2" "dadgarcorp-dev" {
  mount               = vault_mount.gitlab.path
  name                = "dev/cred"
  cas                 = 1
  delete_all_versions = true
  data_json = jsonencode(
    {
      password = "devpass",
      zip      = "zap1",
      foo      = "bar1"
    }
  )
}

resource "vault_kv_secret_v2" "dadgarcorp-prod" {
  mount               = vault_mount.gitlab.path
  name                = "prod/cred"
  cas                 = 1
  delete_all_versions = true
  data_json = jsonencode(
    {
      password = "prodpass",
      zip      = "zap2",
      foo      = "bar2"
    }
  )
}

################################################
# VAULT SECRETS ENGINE: KVv2
# GITLAB NAMESPACE / PARENT GROUP: {{namespace_name}}
# CREATE KVv2 MOUNTS FOR EACH GITLAB PROJECT and SUBGROUP

resource "vault_mount" "dadgarcorp" {
  type        = "kv"
  description = "KVv2 Secret Engine Mount: DadgarCorp"
  options     = { version = "2" }
  path        = "dadgarcorp"
}

################################################
# DADGARCORP

resource "vault_kv_secret_v2" "dadgarcorp_secret" {
  mount               = vault_mount.gitlab.path
  name                = "dadgarcorp"
  cas                 = 1
  delete_all_versions = true
  data_json = jsonencode(
    {
      password = "dadgarcorp-password",
      zip      = "zap-dadgarcorp",
      foo      = "bar-dadgarcorp"
    }
  )
}

################################################
# SUBGROUP A

resource "vault_kv_secret_v2" "dadgarcorp-subgroup-a" {
  # mount               = vault_mount.dadgarcorp.path
  mount               = vault_mount.gitlab.path
  name                = "dadgarcorp/subgroup-${random_pet.group[0].id}"
  cas                 = 1
  delete_all_versions = true
  data_json = jsonencode(
    {
      password = "${random_pet.group[0].id}-password",
      zip      = "zap-a",
      foo      = "bar-a"
    }
  )
}

resource "vault_kv_secret_v2" "dadgarcorp-project-a" {
  # mount               = vault_mount.dadgarcorp.path
  mount               = vault_mount.gitlab.path
  name                = "dadgarcorp/subgroup-${random_pet.group[0].id}/project-${random_pet.group[0].id}"
  cas                 = 1
  delete_all_versions = true
  data_json = jsonencode(
    {
      password = "${random_pet.group[0].id}/project-${random_pet.group[0].id}-password",
      zip      = "zap-a",
      foo      = "bar-a"
    }
  )
}

resource "vault_kv_secret_v2" "dadgarcorp-subgroup-a-a" {
  # mount               = vault_mount.dadgarcorp.path
  mount               = vault_mount.gitlab.path
  name                = "dadgarcorp/subgroup-${random_pet.group[0].id}/subgroup-a-a"
  cas                 = 1
  delete_all_versions = true
  data_json = jsonencode(
    {
      password = "${random_pet.group[0].id}/subgroup-a-a-password",
      zip      = "zap-a-a",
      foo      = "bar-a-a"
    }
  )
}

resource "vault_kv_secret_v2" "dadgarcorp-project-a-a" {
  # mount               = vault_mount.dadgarcorp.path
  mount               = vault_mount.gitlab.path
  name                = "dadgarcorp/subgroup-${random_pet.group[0].id}/subgroup-a-a/project-a-a"
  cas                 = 1
  delete_all_versions = true
  data_json = jsonencode(
    {
      password = "${random_pet.group[0].id}/subgroup-a-a/project-a-a-password",
      zip      = "zap-a-a",
      foo      = "bar-a-a"
    }
  )
}

resource "vault_kv_secret_v2" "dadgarcorp-project-a-a-folder" {
  # mount               = vault_mount.dadgarcorp.path
  mount               = vault_mount.gitlab.path
  name                = "dadgarcorp/subgroup-${random_pet.group[0].id}/subgroup-a-a/project-a-a/project-a-a"
  cas                 = 1
  delete_all_versions = true
  data_json = jsonencode(
    {
      password = "${random_pet.group[0].id}/subgroup-a-a/project-a-a-password",
      zip      = "zap-a-a",
      foo      = "bar-a-a"
    }
  )
}

resource "vault_kv_secret_v2" "dadgarcorp-subgroup-a-a-a" {
  # mount               = vault_mount.dadgarcorp.path
  mount               = vault_mount.gitlab.path
  name                = "dadgarcorp/subgroup-${random_pet.group[0].id}/subgroup-a-a/subgroup-a-a-a"
  cas                 = 1
  delete_all_versions = true
  data_json = jsonencode(
    {
      password = "${random_pet.group[0].id}/subgroup-a-a/subgroup-a-a-a-password",
      zip      = "zap-a-a-a",
      foo      = "bar-a-a-a"
    }
  )
}

resource "vault_kv_secret_v2" "dadgarcorp-project-a-a-a" {
  # mount               = vault_mount.dadgarcorp.path
  mount               = vault_mount.gitlab.path
  name                = "dadgarcorp/subgroup-${random_pet.group[0].id}/subgroup-a-a/subgroup-a-a-a/project-a-a-a"
  cas                 = 1
  delete_all_versions = true
  data_json = jsonencode(
    {
      password = "${random_pet.group[0].id}/subgroup-a-a/subgroup-a-a-a/project-a-a-a-password",
      zip      = "zap-a-a-a",
      foo      = "bar-a-a-a"
    }
  )
}

################################################
# SUBGROUP B

resource "vault_kv_secret_v2" "dadgarcorp-subgroup-b" {
  # mount               = vault_mount.dadgarcorp.path
  mount               = vault_mount.gitlab.path
  name                = "dadgarcorp/subgroup-${random_pet.group[1].id}"
  cas                 = 1
  delete_all_versions = true
  data_json = jsonencode(
    {
      password = "${random_pet.group[1].id}-password",
      zip      = "zap-b",
      foo      = "bar-b"
    }
  )
}

resource "vault_kv_secret_v2" "dadgarcorp-project-b" {
  # mount               = vault_mount.dadgarcorp.path
  mount               = vault_mount.gitlab.path
  name                = "dadgarcorp/subgroup-${random_pet.group[1].id}/project-${random_pet.group[1].id}"
  cas                 = 1
  delete_all_versions = true
  data_json = jsonencode(
    {
      password = "${random_pet.group[1].id}/project-${random_pet.group[1].id}-password",
      zip      = "zap-b",
      foo      = "bar-b"
    }
  )
}

resource "vault_kv_secret_v2" "dadgarcorp-subgroup-b-0" {
  # mount               = vault_mount.dadgarcorp.path
  mount               = vault_mount.gitlab.path
  name                = "dadgarcorp/subgroup-${random_pet.group[1].id}/subgroup-b-0"
  cas                 = 1
  delete_all_versions = true
  data_json = jsonencode(
    {
      password = "${random_pet.group[1].id}/subgroup-b-0-password",
      zip      = "zap-b-0",
      foo      = "bar-b-0"
    }
  )
}

resource "vault_kv_secret_v2" "dadgarcorp-project-b-0" {
  # mount               = vault_mount.dadgarcorp.path
  mount               = vault_mount.gitlab.path
  name                = "dadgarcorp/subgroup-${random_pet.group[1].id}/subgroup-b-0/project-b-0"
  cas                 = 1
  delete_all_versions = true
  data_json = jsonencode(
    {
      password = "${random_pet.group[1].id}/subgroup-b-0/project-b-0",
      zip      = "zap-b-0",
      foo      = "bar-b-0"
    }
  )
}

resource "vault_kv_secret_v2" "dadgarcorp-subgroup-b-0-0" {
  # mount               = vault_mount.dadgarcorp.path
  mount               = vault_mount.gitlab.path
  name                = "dadgarcorp/subgroup-${random_pet.group[1].id}/subgroup-b-0/subgroup-b-0-0"
  cas                 = 1
  delete_all_versions = true
  data_json = jsonencode(
    {
      password = "${random_pet.group[1].id}/subgroup-b-0/subgroup-b-0-0-password",
      zip      = "zap-b-0-0",
      foo      = "bar-b-0-0"
    }
  )
}

resource "vault_kv_secret_v2" "dadgarcorp-project-b-0-0" {
  # mount               = vault_mount.dadgarcorp.path
  mount               = vault_mount.gitlab.path
  name                = "dadgarcorp/subgroup-${random_pet.group[1].id}/subgroup-b-0/subgroup-b-0-0/project-b-0-0"
  cas                 = 1
  delete_all_versions = true
  data_json = jsonencode(
    {
      password = "${random_pet.group[1].id}/subgroup-b-0/subgroup-b-0-0/project-b-0-0-password",
      zip      = "zap-b-0-0",
      foo      = "bar-b-0-0"
    }
  )
}

resource "vault_kv_secret_v2" "dadgarcorp-subgroup-b-0-1" {
  # mount               = vault_mount.dadgarcorp.path
  mount               = vault_mount.gitlab.path
  name                = "dadgarcorp/subgroup-${random_pet.group[1].id}/subgroup-b-0/subgroup-b-0-1"
  cas                 = 1
  delete_all_versions = true
  data_json = jsonencode(
    {
      password = "${random_pet.group[1].id}/subgroup-b-0/subgroup-b-0-1-password",
      zip      = "zap-b-0-1",
      foo      = "bar-b-0-1"
    }
  )
}

resource "vault_kv_secret_v2" "dadgarcorp-project-b-0-1" {
  # mount               = vault_mount.dadgarcorp.path
  mount               = vault_mount.gitlab.path
  name                = "dadgarcorp/subgroup-${random_pet.group[1].id}/subgroup-b-0/subgroup-b-0-1/project-b-0-1"
  cas                 = 1
  delete_all_versions = true
  data_json = jsonencode(
    {
      password = "${random_pet.group[1].id}/subgroup-b-0/subgroup-b-0-1/project-b-0-1-password",
      zip      = "zap-b-0-1",
      foo      = "bar-b-0-1"
    }
  )
}

resource "vault_kv_secret_v2" "dadgarcorp-subgroup-b-0-1-0" {
  # mount               = vault_mount.dadgarcorp.path
  mount               = vault_mount.gitlab.path
  name                = "dadgarcorp/subgroup-${random_pet.group[1].id}/subgroup-b-0/subgroup-b-0-1/subgroup-b-0-1-0"
  cas                 = 1
  delete_all_versions = true
  data_json = jsonencode(
    {
      password = "${random_pet.group[1].id}/subgroup-b-0/subgroup-b-0-1/subgroup-b-0-1-0-password",
      zip      = "zap-b-0-1-0",
      foo      = "bar-b-0-1-0"
    }
  )
}

resource "vault_kv_secret_v2" "dadgarcorp-project-b-0-1-0" {
  # mount               = vault_mount.dadgarcorp.path
  mount               = vault_mount.gitlab.path
  name                = "dadgarcorp/subgroup-${random_pet.group[1].id}/subgroup-b-0/subgroup-b-0-1/subgroup-b-0-1-0/project-b-0-1-0"
  cas                 = 1
  delete_all_versions = true
  data_json = jsonencode(
    {
      password = "${random_pet.group[1].id}/subgroup-b-0/subgroup-b-0-1/subgroup-b-0-1-0/project-b-0-1-0-password",
      zip      = "zap-b-0-1-0",
      foo      = "bar-b-0-1-0"
    }
  )
}

resource "vault_kv_secret_v2" "dadgarcorp-subgroup-b-0-1-1" {
  # mount               = vault_mount.dadgarcorp.path
  mount               = vault_mount.gitlab.path
  name                = "dadgarcorp/subgroup-${random_pet.group[1].id}/subgroup-b-0/subgroup-b-0-1/subgroup-b-0-1-1"
  cas                 = 1
  delete_all_versions = true
  data_json = jsonencode(
    {
      password = "${random_pet.group[1].id}/subgroup-b-0/subgroup-b-0-1/subgroup-b-0-1-1-password",
      zip      = "zap-b-0-1-1",
      foo      = "bar-b-0-1-1"
    }
  )
}

resource "vault_kv_secret_v2" "dadgarcorp-project-b-0-1-1" {
  # mount               = vault_mount.dadgarcorp.path
  mount               = vault_mount.gitlab.path
  name                = "dadgarcorp/subgroup-${random_pet.group[1].id}/subgroup-b-0/subgroup-b-0-1/subgroup-b-0-1-1/project-b-0-1-1"
  cas                 = 1
  delete_all_versions = true
  data_json = jsonencode(
    {
      password = "${random_pet.group[1].id}/subgroup-b-0/subgroup-b-0-1/subgroup-b-0-1-1/project-b-0-1-1-password",
      zip      = "zap-b-0-1-1",
      foo      = "bar-b-0-1-1"
    }
  )
}

resource "vault_kv_secret_v2" "dadgarcorp-subgroup-b-0-1-2" {
  # mount               = vault_mount.dadgarcorp.path
  mount               = vault_mount.gitlab.path
  name                = "dadgarcorp/subgroup-${random_pet.group[1].id}/subgroup-b-0/subgroup-b-0-1/subgroup-b-0-1-2"
  cas                 = 1
  delete_all_versions = true
  data_json = jsonencode(
    {
      password = "${random_pet.group[1].id}/subgroup-b-0/subgroup-b-0-1/subgroup-b-0-1-2-password",
      zip      = "zap-b-0-1-2",
      foo      = "bar-b-0-1-2"
    }
  )
}

resource "vault_kv_secret_v2" "dadgarcorp-project-b-0-1-2" {
  # mount               = vault_mount.dadgarcorp.path
  mount               = vault_mount.gitlab.path
  name                = "dadgarcorp/subgroup-${random_pet.group[1].id}/subgroup-b-0/subgroup-b-0-1/subgroup-b-0-1-2/project-b-0-1-2"
  cas                 = 1
  delete_all_versions = true
  data_json = jsonencode(
    {
      password = "${random_pet.group[1].id}/subgroup-b-0/subgroup-b-0-1/subgroup-b-0-1-2/project-b-0-1-2-password",
      zip      = "zap-b-0-1-2",
      foo      = "bar-b-0-1-2"
    }
  )
}

resource "vault_kv_secret_v2" "dadgarcorp-subgroup-b-0-1-2-0" {
  # mount               = vault_mount.dadgarcorp.path
  mount               = vault_mount.gitlab.path
  name                = "dadgarcorp/subgroup-${random_pet.group[1].id}/subgroup-b-0/subgroup-b-0-1/subgroup-b-0-1-2/subgroup-b-0-1-2-0"
  cas                 = 1
  delete_all_versions = true
  data_json = jsonencode(
    {
      password = "${random_pet.group[1].id}/subgroup-b-0/subgroup-b-0-1/subgroup-b-0-1-2/subgroup-b-0-1-2-0-password",
      zip      = "zap-b-0-1-2-0",
      foo      = "bar-b-0-1-2-0"
    }
  )
}

resource "vault_kv_secret_v2" "dadgarcorp-project-b-0-1-2-0" {
  # mount               = vault_mount.dadgarcorp.path
  mount               = vault_mount.gitlab.path
  name                = "dadgarcorp/subgroup-${random_pet.group[1].id}/subgroup-b-0/subgroup-b-0-1/subgroup-b-0-1-2/subgroup-b-0-1-2-0/project-b-0-1-2-0"
  cas                 = 1
  delete_all_versions = true
  data_json = jsonencode(
    {
      password = "${random_pet.group[1].id}/subgroup-b-0/subgroup-b-0-1/subgroup-b-0-1-2/subgroup-b-0-1-2-0/project-b-0-1-2-0-password",
      zip      = "zap-b-0-1-2-0",
      foo      = "bar-b-0-1-2-0"
    }
  )
}

resource "vault_kv_secret_v2" "dadgarcorp-subgroup-b-0-1-2-1" {
  # mount               = vault_mount.dadgarcorp.path
  mount               = vault_mount.gitlab.path
  name                = "dadgarcorp/subgroup-${random_pet.group[1].id}/subgroup-b-0/subgroup-b-0-1/subgroup-b-0-1-2/subgroup-b-0-1-2-1"
  cas                 = 1
  delete_all_versions = true
  data_json = jsonencode(
    {
      password = "${random_pet.group[1].id}/subgroup-b-0/subgroup-b-0-1/subgroup-b-0-1-2/subgroup-b-0-1-2-1-password",
      zip      = "zap-b-0-1-2-1",
      foo      = "bar-b-0-1-2-1"
    }
  )
}

resource "vault_kv_secret_v2" "dadgarcorp-project-b-0-1-2-1" {
  # mount               = vault_mount.dadgarcorp.path
  mount               = vault_mount.gitlab.path
  name                = "dadgarcorp/subgroup-${random_pet.group[1].id}/subgroup-b-0/subgroup-b-0-1/subgroup-b-0-1-2/subgroup-b-0-1-2-1/project-b-0-1-2-1"
  cas                 = 1
  delete_all_versions = true
  data_json = jsonencode(
    {
      password = "${random_pet.group[1].id}/subgroup-b-0/subgroup-b-0-1/subgroup-b-0-1-2/subgroup-b-0-1-2-1/project-b-0-1-2-1-password",
      zip      = "zap-b-0-1-2-1",
      foo      = "bar-b-0-1-2-1"
    }
  )
}

resource "vault_kv_secret_v2" "dadgarcorp-subgroup-b-0-1-2-2" {
  # mount               = vault_mount.dadgarcorp.path
  mount               = vault_mount.gitlab.path
  name                = "dadgarcorp/subgroup-${random_pet.group[1].id}/subgroup-b-0/subgroup-b-0-1/subgroup-b-0-1-2/subgroup-b-0-1-2-2"
  cas                 = 1
  delete_all_versions = true
  data_json = jsonencode(
    {
      password = "${random_pet.group[1].id}/subgroup-b-0/subgroup-b-0-1/subgroup-b-0-1-2/subgroup-b-0-1-2-2-password",
      zip      = "zap-b-0-1-2-2",
      foo      = "bar-b-0-1-2-2"
    }
  )
}

resource "vault_kv_secret_v2" "dadgarcorp-project-b-0-1-2-2" {
  # mount               = vault_mount.dadgarcorp.path
  mount               = vault_mount.gitlab.path
  name                = "dadgarcorp/subgroup-${random_pet.group[1].id}/subgroup-b-0/subgroup-b-0-1/subgroup-b-0-1-2/subgroup-b-0-1-2-2/project-b-0-1-2-2"
  cas                 = 1
  delete_all_versions = true
  data_json = jsonencode(
    {
      password = "${random_pet.group[1].id}/subgroup-b-0/subgroup-b-0-1/subgroup-b-0-1-2/subgroup-b-0-1-2-2/project-b-0-1-2-2-password",
      zip      = "zap-b-0-1-2-2",
      foo      = "bar-b-0-1-2-2"
    }
  )
}

resource "vault_kv_secret_v2" "dadgarcorp-subgroup-b-0-1-2-3" {
  # mount               = vault_mount.dadgarcorp.path
  mount               = vault_mount.gitlab.path
  name                = "dadgarcorp/subgroup-${random_pet.group[1].id}/subgroup-b-0/subgroup-b-0-1/subgroup-b-0-1-2/subgroup-b-0-1-2-3"
  cas                 = 1
  delete_all_versions = true
  data_json = jsonencode(
    {
      password = "${random_pet.group[1].id}/subgroup-b-0/subgroup-b-0-1/subgroup-b-0-1-2/subgroup-b-0-1-2-3-password",
      zip      = "zap-b-0-1-2-3",
      foo      = "bar-b-0-1-2-3"
    }
  )
}
resource "vault_kv_secret_v2" "dadgarcorp-project-b-0-1-2-3" {
  # mount               = vault_mount.dadgarcorp.path
  mount               = vault_mount.gitlab.path
  name                = "dadgarcorp/subgroup-${random_pet.group[1].id}/subgroup-b-0/subgroup-b-0-1/subgroup-b-0-1-2/subgroup-b-0-1-2-3/project-b-0-1-2-3"
  cas                 = 1
  delete_all_versions = true
  data_json = jsonencode(
    {
      password = "${random_pet.group[1].id}/subgroup-b-0/subgroup-b-0-1/subgroup-b-0-1-2/subgroup-b-0-1-2-3/project-b-0-1-2-3-password",
      zip      = "zap-b-0-1-2-3",
      foo      = "bar-b-0-1-2-3"
    }
  )
}

resource "vault_kv_secret_v2" "dadgarcorp-subgroup-b-1" {
  # mount               = vault_mount.dadgarcorp.path
  mount               = vault_mount.gitlab.path
  name                = "dadgarcorp/subgroup-${random_pet.group[1].id}/subgroup-b-1"
  cas                 = 1
  delete_all_versions = true
  data_json = jsonencode(
    {
      password = "${random_pet.group[1].id}/subgroup-b-1-password",
      zip      = "zap-b-1",
      foo      = "bar-b-1"
    }
  )
}

resource "vault_kv_secret_v2" "dadgarcorp-project-b-1" {
  # mount               = vault_mount.dadgarcorp.path
  mount               = vault_mount.gitlab.path
  name                = "dadgarcorp/subgroup-${random_pet.group[1].id}/subgroup-b-1/project-b-1"
  cas                 = 1
  delete_all_versions = true
  data_json = jsonencode(
    {
      password = "${random_pet.group[1].id}/subgroup-b-1/project-b-1-password",
      zip      = "zap-b-1",
      foo      = "bar-b-1"
    }
  )
}



