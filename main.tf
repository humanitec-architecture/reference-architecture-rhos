# RHOS reference architecture

module "base" {
  source = "./modules/base"

  environment    = var.environment
  basedomain     = var.basedomain
  aws_region     = var.aws_region
  aws_account_id = var.aws_account_id

  humanitec_org_id = var.humanitec_org_id
}

# Connect Humanitec Platform Orchestrator and OpenShift

module "humanitec_k8s_connection" {
  count = var.with_argocd ? 0 : 1

  source = "./modules/humanitec-k8s-connection"

  apiserver   = var.apiserver
  environment = var.environment
  basedomain  = var.basedomain
}

# Deploy ArgoCD as Deployment Solution

module "cd_argocd" {
  count = var.with_argocd ? 1 : 0

  source = "./modules/cd-argocd"

  github_org_id             = var.github_org_id
  github_manifests_repo     = var.github_manifests_repo
  github_manifests_username = var.github_manifests_username
  github_manifests_password = var.github_manifests_password
  basedomain                = var.basedomain
}

# User used for scaffolding and deploying apps

resource "humanitec_user" "deployer" {
  count = var.with_backstage || var.with_rhdh ? 1 : 0

  name = "deployer"
  role = "administrator"
  type = "service"
}

resource "humanitec_service_user_token" "deployer" {
  count = var.with_backstage || var.with_rhdh ? 1 : 0

  id          = "deployer"
  user_id     = humanitec_user.deployer[0].id
  description = "Used by scaffolding and deploying"
}

module "github" {
  count = var.with_backstage || var.with_rhdh ? 1 : 0

  source = "github.com/humanitec-architecture/reference-architecture-aws?ref=v2024-06-11//modules/github"

  humanitec_org_id                = var.humanitec_org_id
  humanitec_ci_service_user_token = humanitec_service_user_token.deployer[0].token
  aws_region                      = var.aws_region
  github_org_id                   = var.github_org_id

  depends_on = [module.base]
}

# Configure GitHub variables & secrets for Backstage itself and for all scaffolded apps

locals {
  github_app_credentials_file = "github-app-credentials.json"
}

module "github_app" {
  count = var.with_backstage || var.with_rhdh ? 1 : 0

  source = "github.com/humanitec-architecture/shared-terraform-modules?ref=v2024-06-10//modules/github-app"

  credentials_file = "${path.module}/${local.github_app_credentials_file}"
}

# Deploy Backstage as Portal

module "portal_backstage" {
  count = var.with_backstage ? 1 : 0

  source = "./modules/portal-backstage"

  humanitec_org_id                        = var.humanitec_org_id
  humanitec_ci_service_user_token         = humanitec_service_user_token.deployer[0].token
  humanitec_secret_store_id               = module.base.humanitec_secret_store_id
  humanitec_imagepullsecret_config_res_id = module.base.humanitec_imagepullsecret_config_res_id

  github_org_id            = var.github_org_id
  github_app_client_id     = module.github_app[0].client_id
  github_app_client_secret = module.github_app[0].client_secret
  github_app_id            = module.github_app[0].app_id
  github_app_private_key   = module.github_app[0].private_key
  github_webhook_secret    = module.github_app[0].webhook_secret

  depends_on = [module.github]
}

# Deploy Red Hat Developer Hub as Portal

module "portal_rhdh" {
  count = var.with_rhdh ? 1 : 0

  source = "./modules/portal-rhdh"

  humanitec_org_id                = var.humanitec_org_id
  humanitec_ci_service_user_token = humanitec_service_user_token.deployer[0].token
  basedomain                      = var.basedomain

  github_org_id            = var.github_org_id
  github_app_client_id     = module.github_app[0].client_id
  github_app_client_secret = module.github_app[0].client_secret
  github_app_id            = module.github_app[0].app_id
  github_app_private_key   = module.github_app[0].private_key
  github_webhook_url       = module.github_app[0].webhook_url
  github_webhook_secret    = module.github_app[0].webhook_secret

  depends_on = [module.github]
}
