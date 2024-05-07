# 02-01.gitlab.projects.tf

################################################
#  SUBGROUP A

resource "gitlab_group" "subgroup_a" {
  # name             = "subgroup-a"
  name        = "subgroup-${random_pet.group[0].id}"
  description = "NameSpace/DadgarCorp SubGroup A"
  # path             = random_pet.group.keepers.pet_name
  path             = "subgroup-${random_pet.group[0].id}"
  parent_id        = var.gitlab_namespace_id
  visibility_level = "private"
}

resource "gitlab_group" "subgroup_a_a" {
  name             = "subgroup-a-a"
  description      = "NameSpace/DadgarCorp SubGroup A-A"
  path             = "subgroup-a-a"
  parent_id        = gitlab_group.subgroup_a.id
  visibility_level = "private"
}

resource "gitlab_group" "subgroup_a_a_a" {
  name             = "subgroup-a-a-a"
  description      = "NameSpace/DadgarCorp SubGroup A-A-A"
  path             = "subgroup-a-a-a"
  parent_id        = gitlab_group.subgroup_a_a.id
  visibility_level = "private"
}

# resource "gitlab_group" "subgroup_a_b" {
#   name = "subgroup-a-b"
#   description = "NameSpace/DadgarCorp SubGroup A-B"
#   path = "subgroup-a-b" 
#   parent_id = gitlab_group.subgroup_a.id
#   visibility_level = "private"
# }

# resource "gitlab_group" "subgroup_a_b_a" {
#   name = "subgroup-a-b-a"
#   description = "NameSpace/DadgarCorp SubGroup A-B-A"
#   path = "subgroup-a-b-a" 
#   parent_id = gitlab_group.subgroup_a_b.id
#   visibility_level = "private"
# }

# resource "gitlab_group" "subgroup_a_b_b" {
#   name = "subgroup-a-b-b"
#   description = "NameSpace/DadgarCorp SubGroup A-B-B"
#   path = "subgroup-a-b-b" 
#   parent_id = gitlab_group.subgroup_a_b.id
#   visibility_level = "private"
# }

# resource "gitlab_group" "subgroup_a_b_b_a" {
#   name = "subgroup-a-b-b-a"
#   description = "NameSpace/DadgarCorp SubGroup A-B-B-A"
#   path = "subgroup-a-b-b-a" 
#   parent_id = gitlab_group.subgroup_a_b_b.id
#   visibility_level = "private"
# }

################################################
#  SUBGROUP B

resource "gitlab_group" "subgroup_b" {
  # name             = "subgroup-b"
  name        = "subgroup-${random_pet.group[1].id}"
  description = "NameSpace/DadgarCorp SubGroup B"
  # path             = random_pet.group.keepers.pet_name
  path             = "subgroup-${random_pet.group[1].id}"
  parent_id        = var.gitlab_namespace_id
  visibility_level = "private"
}

resource "gitlab_group" "subgroup_b_0" {
  name             = "subgroup-b-0"
  description      = "NameSpace/DadgarCorp SubGroup B-0"
  path             = "subgroup-b-0"
  parent_id        = gitlab_group.subgroup_b.id
  visibility_level = "private"
}

resource "gitlab_group" "subgroup_b_0_0" {
  name             = "subgroup-b-0-0"
  description      = "NameSpace/DadgarCorp SubGroup B-0-0"
  path             = "subgroup-b-0-0"
  parent_id        = gitlab_group.subgroup_b_0.id
  visibility_level = "private"
}

resource "gitlab_group" "subgroup_b_0_1" {
  name             = "subgroup-b-0-1"
  description      = "NameSpace/DadgarCorp SubGroup B-0-1"
  path             = "subgroup-b-0-1"
  parent_id        = gitlab_group.subgroup_b_0.id
  visibility_level = "private"
}

resource "gitlab_group" "subgroup_b_0_1_0" {
  name             = "subgroup-b-0-1-0"
  description      = "NameSpace/DadgarCorp SubGroup B-0-1-0"
  path             = "subgroup-b-0-1-0"
  parent_id        = gitlab_group.subgroup_b_0_1.id
  visibility_level = "private"
}

resource "gitlab_group" "subgroup_b_0_1_1" {
  name             = "subgroup-b-0-1-1"
  description      = "NameSpace/DadgarCorp SubGroup B-0-1-1"
  path             = "subgroup-b-0-1-1"
  parent_id        = gitlab_group.subgroup_b_0_1.id
  visibility_level = "private"
}

resource "gitlab_group" "subgroup_b_0_1_2" {
  name             = "subgroup-b-0-1-2"
  description      = "NameSpace/DadgarCorp SubGroup B-0-1-2"
  path             = "subgroup-b-0-1-2"
  parent_id        = gitlab_group.subgroup_b_0_1.id
  visibility_level = "private"
}

resource "gitlab_group" "subgroup_b_0_1_2_0" {
  name             = "subgroup-b-0-1-2-0"
  description      = "NameSpace/DadgarCorp SubGroup B-0-1-2-0"
  path             = "subgroup-b-0-1-2-0"
  parent_id        = gitlab_group.subgroup_b_0_1_2.id
  visibility_level = "private"
}

resource "gitlab_group" "subgroup_b_0_1_2_1" {
  name             = "subgroup-b-0-1-2-1"
  description      = "NameSpace/DadgarCorp SubGroup B-0-1-2-1"
  path             = "subgroup-b-0-1-2-1"
  parent_id        = gitlab_group.subgroup_b_0_1_2.id
  visibility_level = "private"
}

resource "gitlab_group" "subgroup_b_0_1_2_2" {
  name             = "subgroup-b-0-1-2-2"
  description      = "NameSpace/DadgarCorp SubGroup B-0-1-2-2"
  path             = "subgroup-b-0-1-2-2"
  parent_id        = gitlab_group.subgroup_b_0_1_2.id
  visibility_level = "private"
}

resource "gitlab_group" "subgroup_b_0_1_2_3" {
  name             = "subgroup-b-0-1-2-3"
  description      = "NameSpace/DadgarCorp SubGroup B-0-1-2-3"
  path             = "subgroup-b-0-1-2-3"
  parent_id        = gitlab_group.subgroup_b_0_1_2.id
  visibility_level = "private"
}

resource "gitlab_group" "subgroup_b_1" {
  name             = "subgroup-b-1"
  description      = "NameSpace/DadgarCorp SubGroup B-1"
  path             = "subgroup-b-1"
  parent_id        = gitlab_group.subgroup_b.id
  visibility_level = "private"
}


