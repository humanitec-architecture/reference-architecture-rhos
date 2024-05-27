# Configure required resources for example apps

locals {
  res_def_prefix = "default-"
}

# in-cluster postgres

module "default_postgres" {
  # Not pinned as we don't have a release yet
  # tflint-ignore: terraform_module_pinned_source
  source = "git::https://github.com/humanitec-architecture/resource-packs-in-cluster.git//humanitec-resource-defs/postgres/basic"

  prefix = local.res_def_prefix
}

resource "humanitec_resource_definition_criteria" "default_postgres" {
  resource_definition_id = module.default_postgres.id
  env_type               = var.environment
}

module "default_mysql" {
  # Not pinned as we don't have a release yet
  # tflint-ignore: terraform_module_pinned_source
  source = "git::https://github.com/humanitec-architecture/resource-packs-in-cluster.git//humanitec-resource-defs/mysql/basic"

  prefix = local.res_def_prefix
}

resource "humanitec_resource_definition_criteria" "default_mysql" {
  resource_definition_id = module.default_mysql.id
  env_type               = var.environment
}
