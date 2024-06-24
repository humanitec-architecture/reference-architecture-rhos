# Configures GitHub

locals {
  git_url = "https://github.com/${var.github_org_id}/${var.github_manifests_repo}.git"
}

resource "github_repository" "manifests" {
  name        = var.github_manifests_repo
  description = "Humanitec Application Manifests"

  visibility = "private"
  auto_init  = true
}
