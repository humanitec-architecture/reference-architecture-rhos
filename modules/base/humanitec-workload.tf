resource "aws_iam_user" "humanitec_ecr_pull" {
  name = "humanitec_ecr_pull"
}

resource "aws_iam_user_policy_attachment" "humanitec_ecr_pull" {
  user = aws_iam_user.humanitec_ecr_pull.name
  # https://docs.aws.amazon.com/AmazonECR/latest/userguide/security-iam-awsmanpol.html#security-iam-awsmanpol-AmazonEC2ContainerRegistryReadOnly
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_iam_access_key" "humanitec_ecr_pull" {
  user = aws_iam_user.humanitec_ecr_pull.name

  # Ensure that the policy is not deleted before the access key
  depends_on = [aws_iam_user_policy_attachment.humanitec_ecr_pull]
}

locals {
  ecr_pull_secrets = {
    aws-access-key-id     = aws_iam_access_key.humanitec_ecr_pull.id
    aws-secret-access-key = aws_iam_access_key.humanitec_ecr_pull.secret
  }

  ecr_pull_secret_refs = {
    for key, value in local.ecr_pull_secrets : key => {
      ref     = aws_secretsmanager_secret.ecr_pull[key].name
      store   = var.humanitec_secret_store_id
      version = aws_secretsmanager_secret_version.ecr_pull[key].version_id
    }
  }
}

resource "aws_secretsmanager_secret" "ecr_pull" {
  for_each = local.ecr_pull_secrets
  name     = "humanitec-ecr-pull-secret-${each.key}"
}

resource "aws_secretsmanager_secret_version" "ecr_pull" {
  for_each = local.ecr_pull_secrets

  secret_id     = aws_secretsmanager_secret.ecr_pull[each.key].id
  secret_string = each.value
}

locals {
  imagepullsecret_config_res_id = "imagepullsecret"
}

module "config_imagepullsecret" {
  source = "github.com/humanitec-architecture/resource-packs-aws?ref=v2024-06-14//humanitec-resource-defs/config/imagepullsecret"

  prefix = "default-"

  account_id            = data.aws_caller_identity.current.account_id
  region                = var.aws_region
  access_key_id_ref     = local.ecr_pull_secret_refs["aws-access-key-id"]
  secret_access_key_ref = local.ecr_pull_secret_refs["aws-secret-access-key"]
}

resource "humanitec_resource_definition_criteria" "default_config_imagepullsecret" {
  resource_definition_id = module.config_imagepullsecret.id
  env_type               = var.environment
  res_id                 = local.imagepullsecret_config_res_id
  class                  = "default"

  force_delete = true
}

resource "humanitec_resource_definition" "default_workload" {
  driver_type = "humanitec/template"
  id          = "default-workload"
  name        = "default-workload"
  type        = "workload"

  driver_inputs = {
    values_string = jsonencode({
      templates = {
        outputs = <<EOL
update:
- op: add
  path: /spec/imagePullSecrets
  value:
    - name: $${resources["config.default#${local.imagepullsecret_config_res_id}"].outputs.secret_name}
EOL
      }
    })
  }
}

resource "humanitec_resource_definition_criteria" "default_workload" {
  resource_definition_id = humanitec_resource_definition.default_workload.id
  env_type               = var.environment

  force_delete = true
}
