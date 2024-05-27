# Portal: Red Hat Developer Hub

This module deploys the [Red Hat Developer Hub](https://developers.redhat.com/rhdh/overview) into an Red Hat OpenShift cluster.

## Terraform docs

<!-- BEGIN_TF_DOCS -->
### Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.3.0 |
| kubernetes | ~> 2.30 |
| random | ~> 3.5 |

### Providers

| Name | Version |
|------|---------|
| kubernetes | ~> 2.30 |
| random | ~> 3.5 |

### Resources

| Name | Type |
|------|------|
| [kubernetes_manifest.rhdh_app_configmap](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/manifest) | resource |
| [kubernetes_manifest.rhdh_dynamic_plugins_configmap](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/manifest) | resource |
| [kubernetes_manifest.rhdh_instance](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/manifest) | resource |
| [kubernetes_manifest.rhdh_operator_group](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/manifest) | resource |
| [kubernetes_manifest.rhdh_operator_subscription](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/manifest) | resource |
| [kubernetes_namespace_v1.rhdh](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace_v1) | resource |
| [kubernetes_namespace_v1.rhdh_operator](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace_v1) | resource |
| [kubernetes_secret_v1.rhdh_github_secrets](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret_v1) | resource |
| [kubernetes_secret_v1.rhdh_secrets](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret_v1) | resource |
| [random_bytes.backstage_service_to_service_auth_key](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/bytes) | resource |

### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| basedomain | Base domain | `string` | n/a | yes |
| github\_app\_client\_id | GitHub App Client ID | `string` | n/a | yes |
| github\_app\_client\_secret | GitHub App Client Secret | `string` | n/a | yes |
| github\_app\_id | GitHub App ID | `string` | n/a | yes |
| github\_app\_private\_key | GitHub App Private Key | `string` | n/a | yes |
| github\_org\_id | GitHub org id | `string` | n/a | yes |
| github\_webhook\_secret | GitHub Webhook Secret | `string` | n/a | yes |
| github\_webhook\_url | GitHub Webhook URL | `string` | n/a | yes |
| humanitec\_ci\_service\_user\_token | Humanitec CI Service User Token | `string` | n/a | yes |
| humanitec\_org\_id | Humanitec Organization ID | `string` | n/a | yes |
<!-- END_TF_DOCS -->
