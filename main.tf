# RHOS reference architecture

module "base" {
  source = "./modules/base"

  apiserver   = var.apiserver
  environment = var.environment
  basedomain  = var.basedomain
  aws_region  = var.aws_region
}

module "github" {
  count = var.with_backstage || var.with_rhdh ? 1 : 0

  source = "./modules/github"

  humanitec_org_id                = var.humanitec_org_id
  humanitec_ci_service_user_token = var.humanitec_ci_service_user_token
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

  source = "./modules/github-app"

  credentials_file = "${path.module}/${local.github_app_credentials_file}"
}

# Deploy Backstage as Portal

module "portal_backstage" {
  count = var.with_backstage ? 1 : 0

  source = "./modules/portal-backstage"

  aws_region                      = var.aws_region
  humanitec_org_id                = var.humanitec_org_id
  humanitec_ci_service_user_token = var.humanitec_ci_service_user_token

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
  humanitec_ci_service_user_token = var.humanitec_ci_service_user_token
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