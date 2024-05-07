# 02-01.gitlab.projects.tf

################################################
# PROJECTS

resource "gitlab_project" "dadgarcorp_alice" {
  name             = "alice"
  description      = "DadgarCorp Project Alice"
  path             = "alice"
  namespace_id     = var.gitlab_namespace_id
  visibility_level = "private"
}

################################################
# PROJECTS: SUBGROUP A

resource "gitlab_project" "project_a" {
  name             = "project-${random_pet.group[0].id}"
  description      = "DadgarCorp SubGroup A Project"
  path             = "project-${random_pet.group[0].id}"
  namespace_id     = gitlab_group.subgroup_a.id
  visibility_level = "private"
}

# PROJECTS: SUBGROUP A-A

resource "gitlab_project" "project_a_a" {
  name             = "project-a-a"
  description      = "DadgarCorp SubGroup A-A Project"
  path             = "project-a-a"
  namespace_id     = gitlab_group.subgroup_a_a.id
  visibility_level = "private"
}

# PROJECTS: SUBGROUP A-A-A
resource "gitlab_project" "project_a_a_a" {
  name             = "project-a-a-a"
  description      = "DadgarCorp SubGroup A-A-A Project"
  path             = "project-a-a-a"
  namespace_id     = gitlab_group.subgroup_a_a_a.id
  visibility_level = "private"
}

################################################
# PROJECTS: SUBGROUP B

resource "gitlab_project" "project_b" {
  name             = "project-${random_pet.group[1].id}"
  description      = "DadgarCorp SubGroup B Project"
  path             = "project-${random_pet.group[1].id}"
  namespace_id     = gitlab_group.subgroup_b.id
  visibility_level = "private"
}

# PROJECTS: SUBGROUP B-0

resource "gitlab_project" "project_b_0" {
  name             = "project-b-0"
  description      = "DadgarCorp SubGroup B-0 Project"
  path             = "project-b-0"
  namespace_id     = gitlab_group.subgroup_b_0.id
  visibility_level = "private"
}

# PROJECTS: SUBGROUP B-0-0

resource "gitlab_project" "project_b_0_0" {
  name             = "project-b-0-0"
  description      = "DadgarCorp SubGroup B-0-0 Project"
  path             = "project-b-0-0"
  namespace_id     = gitlab_group.subgroup_b_0_0.id
  visibility_level = "private"
}

# PROJECTS: SUBGROUP B-0-1

resource "gitlab_project" "project_b_0_1" {
  name             = "project-b-0-1"
  description      = "DadgarCorp SubGroup B-0-1 Project"
  path             = "project-b-0-1"
  namespace_id     = gitlab_group.subgroup_b_0_1.id
  visibility_level = "private"
}

# PROJECTS: SUBGROUP B-0-1-0

resource "gitlab_project" "project_b_0_1_0" {
  name             = "project-b-0-1-0"
  description      = "DadgarCorp SubGroup B-0-1-0 Project"
  path             = "project-b-0-1-0"
  namespace_id     = gitlab_group.subgroup_b_0_1_0.id
  visibility_level = "private"
}

# PROJECTS: SUBGROUP B-0-1-1

resource "gitlab_project" "project_b_0_1_1" {
  name             = "project-b-0-1-1"
  description      = "DadgarCorp SubGroup B-0-1-1 Project"
  path             = "project-b-0-1-1"
  namespace_id     = gitlab_group.subgroup_b_0_1_1.id
  visibility_level = "private"
}

# PROJECTS: SUBGROUP B-0-1-2

resource "gitlab_project" "project_b_0_1_2" {
  name             = "project-b-0-1-2"
  description      = "DadgarCorp SubGroup B-0-1-2 Project"
  path             = "project-b-0-1-2"
  namespace_id     = gitlab_group.subgroup_b_0_1_2.id
  visibility_level = "private"
}

# PROJECTS: SUBGROUP B-0-1-2-0

resource "gitlab_project" "project_b_0_1_2_0" {
  name             = "project-b-0-1-2-0"
  description      = "DadgarCorp SubGroup B-0-1-2-0 Project"
  path             = "project-b-0-1-2-0"
  namespace_id     = gitlab_group.subgroup_b_0_1_2_0.id
  visibility_level = "private"
}

# PROJECTS: SUBGROUP B-0-1-2-1

resource "gitlab_project" "project_b_0_1_2_1" {
  name             = "project-b-0-1-2-1"
  description      = "DadgarCorp SubGroup B-0-1-2-1 Project"
  path             = "project-b-0-1-2-1"
  namespace_id     = gitlab_group.subgroup_b_0_1_2_1.id
  visibility_level = "private"
}

# PROJECTS: SUBGROUP B-0-1-2-2

resource "gitlab_project" "project_b_0_1_2_2" {
  name             = "project-b-0-1-2-2"
  description      = "DadgarCorp SubGroup B-0-1-2-2 Project"
  path             = "project-b-0-1-2-2"
  namespace_id     = gitlab_group.subgroup_b_0_1_2_2.id
  visibility_level = "private"
}

# PROJECTS: SUBGROUP B-0-1-2-3

resource "gitlab_project" "project_b_0_1_2_3" {
  name             = "project-b-0-1-2-3"
  description      = "DadgarCorp SubGroup B-0-1-2-3 Project"
  path             = "project-b-0-1-2-3"
  namespace_id     = gitlab_group.subgroup_b_0_1_2_3.id
  visibility_level = "private"
}

# PROJECTS: SUBGROUP B-1

resource "gitlab_project" "project_b_1" {
  name             = "project-b-1"
  description      = "DadgarCorp SubGroup B-1 Project"
  path             = "project-b-1"
  namespace_id     = gitlab_group.subgroup_b_1.id
  visibility_level = "private"
}
