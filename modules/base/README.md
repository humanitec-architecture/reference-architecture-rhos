# Base

This module connects an existing Red Hat OpenShift cluster with Humanitec.

## Terraform docs

<!-- BEGIN_TF_DOCS -->
### Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.3.0 |
| aws | ~> 5.17 |
| humanitec | ~> 1.0 |
| kubernetes | ~> 2.30 |

### Providers

| Name | Version |
|------|---------|
| aws | ~> 5.17 |
| humanitec | ~> 1.0 |
| kubernetes | ~> 2.30 |

### Modules

| Name | Source | Version |
|------|--------|---------|
| default\_mysql | git::https://github.com/humanitec-architecture/resource-packs-in-cluster.git//humanitec-resource-defs/mysql/basic | n/a |
| default\_postgres | git::https://github.com/humanitec-architecture/resource-packs-in-cluster.git//humanitec-resource-defs/postgres/basic | n/a |

### Resources

| Name | Type |
|------|------|
| [aws_iam_access_key.humanitec_svc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_access_key) | resource |
| [aws_iam_user.humanitec_svc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user) | resource |
| [aws_iam_user_policy_attachment.humanitec_svc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user_policy_attachment) | resource |
| [humanitec_registry.ref-arc-ecr](https://registry.terraform.io/providers/humanitec/humanitec/latest/docs/resources/registry) | resource |
| [humanitec_resource_definition.k8s_cluster_driver](https://registry.terraform.io/providers/humanitec/humanitec/latest/docs/resources/resource_definition) | resource |
| [humanitec_resource_definition.k8s_namespace](https://registry.terraform.io/providers/humanitec/humanitec/latest/docs/resources/resource_definition) | resource |
| [humanitec_resource_definition.rhos_ingress](https://registry.terraform.io/providers/humanitec/humanitec/latest/docs/resources/resource_definition) | resource |
| [humanitec_resource_definition_criteria.default_mysql](https://registry.terraform.io/providers/humanitec/humanitec/latest/docs/resources/resource_definition_criteria) | resource |
| [humanitec_resource_definition_criteria.default_postgres](https://registry.terraform.io/providers/humanitec/humanitec/latest/docs/resources/resource_definition_criteria) | resource |
| [humanitec_resource_definition_criteria.k8s_cluster_driver](https://registry.terraform.io/providers/humanitec/humanitec/latest/docs/resources/resource_definition_criteria) | resource |
| [humanitec_resource_definition_criteria.k8s_namespace](https://registry.terraform.io/providers/humanitec/humanitec/latest/docs/resources/resource_definition_criteria) | resource |
| [humanitec_resource_definition_criteria.rhos_ingress](https://registry.terraform.io/providers/humanitec/humanitec/latest/docs/resources/resource_definition_criteria) | resource |
| [kubernetes_cluster_role_binding_v1.humanitec_cluster_admin](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/cluster_role_binding_v1) | resource |
| [kubernetes_namespace_v1.humanitec_system](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace_v1) | resource |
| [kubernetes_secret_v1.humanitec_service_account](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret_v1) | resource |
| [kubernetes_service_account_v1.humanitec](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service_account_v1) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |

### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| apiserver | The API server URL of your OpenShift cluster | `string` | n/a | yes |
| aws\_region | AWS region | `string` | n/a | yes |
| basedomain | Base domain | `string` | n/a | yes |
| cluster\_res\_def\_name | Cluster Resource Definition Name | `string` | `"ref-arch"` | no |
| environment | Environment | `string` | `"development"` | no |
<!-- END_TF_DOCS -->
