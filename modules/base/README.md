# Base

This module connects an existing Red Hat OpenShift cluster with Humanitec.

## Terraform docs

<!-- BEGIN_TF_DOCS -->
### Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.3.0 |
| aws | ~> 5.17 |
| helm | ~> 2.13 |
| humanitec | ~> 1.0 |
| kubectl | ~> 2.0 |
| kubernetes | ~> 2.0 |
| random | ~> 3.5 |
| tls | ~> 4.0 |

### Providers

| Name | Version |
|------|---------|
| aws | ~> 5.17 |
| helm | ~> 2.13 |
| humanitec | ~> 1.0 |
| kubectl | ~> 2.0 |
| kubernetes | ~> 2.0 |
| tls | ~> 4.0 |

### Modules

| Name | Source | Version |
|------|--------|---------|
| config\_imagepullsecret | github.com/humanitec-architecture/resource-packs-aws | v2024-06-14//humanitec-resource-defs/config/imagepullsecret |
| default\_mysql | github.com/humanitec-architecture/resource-packs-in-cluster | v2024-06-07//humanitec-resource-defs/mysql/basic |
| default\_postgres | github.com/humanitec-architecture/resource-packs-in-cluster | v2024-06-07//humanitec-resource-defs/postgres/basic |

### Resources

| Name | Type |
|------|------|
| [aws_iam_access_key.humanitec_ecr_pull](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_access_key) | resource |
| [aws_iam_access_key.humanitec_operator](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_access_key) | resource |
| [aws_iam_policy.humanitec_operator](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_user.humanitec_ecr_pull](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user) | resource |
| [aws_iam_user.humanitec_operator](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user) | resource |
| [aws_iam_user_policy_attachment.humanitec_ecr_pull](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user_policy_attachment) | resource |
| [aws_iam_user_policy_attachment.humanitec_operator](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user_policy_attachment) | resource |
| [aws_secretsmanager_secret.ecr_pull](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret_version.ecr_pull](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [helm_release.humanitec_operator](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [humanitec_key.operator_public_key](https://registry.terraform.io/providers/humanitec/humanitec/latest/docs/resources/key) | resource |
| [humanitec_resource_definition.default_workload](https://registry.terraform.io/providers/humanitec/humanitec/latest/docs/resources/resource_definition) | resource |
| [humanitec_resource_definition.emptydir_volume](https://registry.terraform.io/providers/humanitec/humanitec/latest/docs/resources/resource_definition) | resource |
| [humanitec_resource_definition.k8s_namespace](https://registry.terraform.io/providers/humanitec/humanitec/latest/docs/resources/resource_definition) | resource |
| [humanitec_resource_definition.rhos_dns](https://registry.terraform.io/providers/humanitec/humanitec/latest/docs/resources/resource_definition) | resource |
| [humanitec_resource_definition.rhos_ingress](https://registry.terraform.io/providers/humanitec/humanitec/latest/docs/resources/resource_definition) | resource |
| [humanitec_resource_definition_criteria.default_config_imagepullsecret](https://registry.terraform.io/providers/humanitec/humanitec/latest/docs/resources/resource_definition_criteria) | resource |
| [humanitec_resource_definition_criteria.default_mysql](https://registry.terraform.io/providers/humanitec/humanitec/latest/docs/resources/resource_definition_criteria) | resource |
| [humanitec_resource_definition_criteria.default_postgres](https://registry.terraform.io/providers/humanitec/humanitec/latest/docs/resources/resource_definition_criteria) | resource |
| [humanitec_resource_definition_criteria.default_workload](https://registry.terraform.io/providers/humanitec/humanitec/latest/docs/resources/resource_definition_criteria) | resource |
| [humanitec_resource_definition_criteria.emptydir_volume](https://registry.terraform.io/providers/humanitec/humanitec/latest/docs/resources/resource_definition_criteria) | resource |
| [humanitec_resource_definition_criteria.k8s_namespace](https://registry.terraform.io/providers/humanitec/humanitec/latest/docs/resources/resource_definition_criteria) | resource |
| [humanitec_resource_definition_criteria.rhos_dns](https://registry.terraform.io/providers/humanitec/humanitec/latest/docs/resources/resource_definition_criteria) | resource |
| [humanitec_resource_definition_criteria.rhos_ingress](https://registry.terraform.io/providers/humanitec/humanitec/latest/docs/resources/resource_definition_criteria) | resource |
| [humanitec_secretstore.main](https://registry.terraform.io/providers/humanitec/humanitec/latest/docs/resources/secretstore) | resource |
| [kubectl_manifest.humanitec_operator_secret_store](https://registry.terraform.io/providers/alekc/kubectl/latest/docs/resources/manifest) | resource |
| [kubernetes_namespace.humanitec_operator](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |
| [kubernetes_secret.humanitec_operator](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [kubernetes_secret.humanitec_operator_awssm_credentials](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [tls_private_key.operator_private_key](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.humanitec_operator](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| aws\_account\_id | AWS Account (ID) | `string` | n/a | yes |
| aws\_region | AWS region | `string` | n/a | yes |
| basedomain | Base domain | `string` | n/a | yes |
| humanitec\_org\_id | Humanitec Organization ID | `string` | n/a | yes |
| environment | Environment | `string` | `"development"` | no |
| humanitec\_secret\_store\_id | Humanitec Secret Store ID | `string` | `"ref-arch"` | no |

### Outputs

| Name | Description |
|------|-------------|
| humanitec\_imagepullsecret\_config\_res\_id | Humanitec imagepullsecret config resource id |
| humanitec\_secret\_store\_id | Humanitec secret store id |
<!-- END_TF_DOCS -->
