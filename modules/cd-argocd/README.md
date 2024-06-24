# CD: ArgoCD

This module deploys the [ArgoCD](https://github.com/argoproj/argo-cd) as continuous deployment solution.

## Terraform docs

<!-- BEGIN_TF_DOCS -->
### Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.3.0 |
| github | ~> 5.38 |
| humanitec | ~> 1.0 |
| kubernetes | ~> 2.30 |
| time | ~> 0.11 |

### Providers

| Name | Version |
|------|---------|
| github | ~> 5.38 |
| humanitec | ~> 1.0 |
| kubernetes | ~> 2.30 |
| time | ~> 0.11 |

### Resources

| Name | Type |
|------|------|
| [github_repository.manifests](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository) | resource |
| [humanitec_resource_definition.k8s_cluster_git](https://registry.terraform.io/providers/humanitec/humanitec/latest/docs/resources/resource_definition) | resource |
| [humanitec_resource_definition_criteria.k8s_cluster_git](https://registry.terraform.io/providers/humanitec/humanitec/latest/docs/resources/resource_definition_criteria) | resource |
| [kubernetes_manifest.argocd_applicationset](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/manifest) | resource |
| [kubernetes_manifest.argocd_instance](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/manifest) | resource |
| [kubernetes_manifest.argocd_operator_group](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/manifest) | resource |
| [kubernetes_manifest.argocd_operator_subscription](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/manifest) | resource |
| [kubernetes_namespace_v1.argocd](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace_v1) | resource |
| [kubernetes_namespace_v1.argocd_operator](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace_v1) | resource |
| [kubernetes_secret_v1.argocd_manifests_repo_credentials](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret_v1) | resource |
| [time_sleep.argocd_instance_ready](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) | resource |
| [time_sleep.argocd_operator_ready](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) | resource |

### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| basedomain | Base domain | `string` | n/a | yes |
| github\_manifests\_password | GitHub password to pull & push manifests | `string` | n/a | yes |
| github\_manifests\_repo | GitHub repository for manifests | `string` | n/a | yes |
| github\_manifests\_username | GitHub username to pull & push manifests | `string` | n/a | yes |
| github\_org\_id | GitHub org id | `string` | n/a | yes |
| environment | Environment | `string` | `"development"` | no |
<!-- END_TF_DOCS -->
