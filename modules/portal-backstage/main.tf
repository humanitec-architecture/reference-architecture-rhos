resource "humanitec_application" "backstage" {
  id   = "backstage"
  name = "backstage"
}

# Configure required values for backstage

resource "humanitec_value" "backstage_github_org_id" {
  app_id      = humanitec_application.backstage.id
  key         = "GITHUB_ORG_ID"
  description = ""
  value       = var.github_org_id
  is_secret   = false
}

resource "humanitec_value" "backstage_github_app_id" {
  app_id      = humanitec_application.backstage.id
  key         = "GITHUB_APP_ID"
  description = ""
  value       = var.github_app_id
  is_secret   = false
}

resource "humanitec_value" "backstage_github_app_client_id" {
  app_id      = humanitec_application.backstage.id
  key         = "GITHUB_APP_CLIENT_ID"
  description = ""
  value       = var.github_app_client_id
  is_secret   = true
}

resource "humanitec_value" "backstage_github_app_client_secret" {
  app_id      = humanitec_application.backstage.id
  key         = "GITHUB_APP_CLIENT_SECRET"
  description = ""
  value       = var.github_app_client_secret
  is_secret   = true
}

resource "humanitec_value" "backstage_github_app_private_key" {
  app_id      = humanitec_application.backstage.id
  key         = "GITHUB_APP_PRIVATE_KEY"
  description = ""
  value       = indent(2, var.github_app_private_key)
  is_secret   = true
}

resource "humanitec_value" "backstage_github_app_webhook_secret" {
  app_id      = humanitec_application.backstage.id
  key         = "GITHUB_APP_WEBHOOK_SECRET"
  description = ""
  value       = var.github_webhook_secret
  is_secret   = true
}

resource "humanitec_value" "backstage_humanitec_org" {
  app_id      = humanitec_application.backstage.id
  key         = "HUMANITEC_ORG_ID"
  description = ""
  value       = var.humanitec_org_id
  is_secret   = false
}

resource "humanitec_value" "backstage_humanitec_token" {
  app_id      = humanitec_application.backstage.id
  key         = "HUMANITEC_TOKEN"
  description = ""
  value       = var.humanitec_ci_service_user_token
  is_secret   = true
}

resource "humanitec_value" "backstage_cloud_provider" {
  app_id      = humanitec_application.backstage.id
  key         = "CLOUD_PROVIDER"
  description = ""
  value       = local.cloud_provider
  is_secret   = false
}

resource "humanitec_value" "aws_default_region" {
  app_id      = humanitec_application.backstage.id
  key         = "AWS_DEFAULT_REGION"
  description = ""
  value       = var.aws_region
  is_secret   = false
}

resource "random_bytes" "backstage_service_to_service_auth_key" {
  length = 24
}

resource "humanitec_value" "app_config_backend_auth_keys" {
  app_id      = humanitec_application.backstage.id
  key         = "APP_CONFIG_backend_auth_keys"
  description = "Backstage service-to-service-auth keys"
  value = jsonencode([{
    secret = random_bytes.backstage_service_to_service_auth_key.base64
  }])
  is_secret = true
}

# Configure required resources for backstage

locals {
  res_def_prefix = "backstage-"
}

# in-cluster postgres

module "backstage_postgres" {
  # Not pinned as we don't have a release yet
  # tflint-ignore: terraform_module_pinned_source
  source = "git::https://github.com/humanitec-architecture/resource-packs-in-cluster.git//humanitec-resource-defs/postgres/basic"

  prefix = local.res_def_prefix
}

resource "humanitec_resource_definition_criteria" "backstage_postgres" {
  resource_definition_id = module.backstage_postgres.id
  app_id                 = humanitec_application.backstage.id

  force_delete = true
}

resource "humanitec_resource_definition" "no_scc_for_backstage_app" {
  driver_type = "humanitec/template"
  id          = "no-scc-for-backstage-app"
  name        = "no-scc-for-backstage-app"
  type        = "workload"

  driver_inputs = {
    values_string = jsonencode({
      templates = {
        manifests = <<EOL
sa.yaml:
  location: cluster
  data:
    apiVersion: v1
    kind: ServiceAccount
    metadata:
      name: backstage-development-backstage
scc.yaml:
  location: namespace
  data:
    kind: SecurityContextConstraints
    apiVersion: security.openshift.io/v1
    metadata:
      name: privileged-scc
    allowPrivilegedContainer: true
    runAsUser:
      type: RunAsAny
    seLinuxContext:
      type: RunAsAny
cr.yaml:
  location: cluster
  data:
    apiVersion: rbac.authorization.k8s.io/v1
    kind: ClusterRole
    metadata:
      name: privileged-role
    rules:
    - apiGroups:
      - security.openshift.io
      resourceNames:
      - privileged-scc
      resources:
      - securitycontextconstraints
      verbs:
      - use
crb.yaml:
  location: cluster
  data:
    apiVersion: rbac.authorization.k8s.io/v1
    kind: ClusterRoleBinding
    metadata:
      name: privileged-binding
    subjects:
    - kind: ServiceAccount
      name: backstage-development-backstage
      namespace: $${resources["k8s-namespace.default#k8s-namespace"].outputs.namespace}
    roleRef:
      kind: ClusterRole
      name: privileged-role
      apiGroup: rbac.authorization.k8s.io
EOL
        outputs   = <<EOL
update:
  - op: add
    path: /spec/securityContext
    value:
      runAsUser: 0
  - op: add
    path: /spec/serviceAccount
    value:
      backstage-development-backstage
  - op: add
    path: /spec/serviceAccountName
    value:
      backstage-development-backstage
EOL
      }
    })
  }
}

resource "humanitec_resource_definition_criteria" "no_scc_for_backstage_app" {
  resource_definition_id = humanitec_resource_definition.no_scc_for_backstage_app.id
  app_id                 = humanitec_application.backstage.id
}
