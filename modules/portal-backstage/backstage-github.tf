locals {
  backstage_repo = "backstage"
  cloud_provider = "aws"
}

# Backstage repository itself

resource "github_repository" "backstage" {
  name        = local.backstage_repo
  description = "Backstage"

  visibility = "public"

  template {
    owner      = "humanitec-architecture"
    repository = "backstage"
  }

  depends_on = [
    module.backstage_ecr,
    humanitec_application.backstage,
    humanitec_resource_definition_criteria.backstage_postgres,
  ]
}
