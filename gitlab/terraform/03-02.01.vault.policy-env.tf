# 01-02.vault.policies.tf

################################################
# VAULT POLICIES
################################################

################################################
# SIMPLE
# Environment Based Policy - GitLab Environment JWT Claim

# ./templates.p.dev.r.tpl
# Allow read access to the dev secrets path
resource "vault_policy" "dev_read" {
  name   = "p.dev.r"
  policy = templatefile("${path.module}/templates/p.dev.r.tpl", {})
}

# ./templates.p.prod.r.tpl
# Allow read access to the prod secrets path
resource "vault_policy" "prod_read" {
  name   = "p.prod.r"
  policy = templatefile("${path.module}/templates/p.prod.r.tpl", {})
}
