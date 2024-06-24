# Humanitec K8s Connection

This module provisions the connection between an existing OpenShift Kubernetes cluster and the Humanitec Platform Orchestrator.

## Terraform docs

<!-- BEGIN_TF_DOCS -->
### Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.3.0 |
| humanitec | ~> 1.0 |
| kubernetes | ~> 2.30 |

### Providers

| Name | Version |
|------|---------|
| humanitec | ~> 1.0 |
| kubernetes | ~> 2.30 |

### Resources

| Name | Type |
|------|------|
| [humanitec_resource_definition.k8s_cluster_driver](https://registry.terraform.io/providers/humanitec/humanitec/latest/docs/resources/resource_definition) | resource |
| [humanitec_resource_definition_criteria.k8s_cluster_driver](https://registry.terraform.io/providers/humanitec/humanitec/latest/docs/resources/resource_definition_criteria) | resource |
| [kubernetes_cluster_role_binding_v1.humanitec_cluster_admin](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/cluster_role_binding_v1) | resource |
| [kubernetes_namespace_v1.humanitec_system](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace_v1) | resource |
| [kubernetes_secret_v1.humanitec_service_account](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret_v1) | resource |
| [kubernetes_service_account_v1.humanitec](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service_account_v1) | resource |

### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| apiserver | The API server URL of your OpenShift cluster | `string` | n/a | yes |
| basedomain | Base domain | `string` | n/a | yes |
| environment | Environment | `string` | `"development"` | no |
| res\_def\_name | k8s-cluster resource definition name | `string` | `"ref-arch"` | no |
<!-- END_TF_DOCS -->