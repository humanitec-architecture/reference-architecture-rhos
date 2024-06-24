# Configures Humanitec for GitOps

## Resource definitions for k8s cluster
resource "humanitec_resource_definition" "k8s_cluster_git" {
  driver_type = "humanitec/template"
  id          = "ref-arch-git"
  name        = "ref-arch-git"
  type        = "k8s-cluster"

  driver_inputs = {
    secrets_string = jsonencode({
      "password" = var.github_manifests_password
    })

    values_string = jsonencode({
      templates = {
        outputs = <<EOL
cluster_type: git
branch: ""                          # Currently a bug means this must *always* be an empty string
loadbalancer: "router-default.${var.basedomain}"
path: "$${context.app.id}/$${context.env.id}"
url: "${local.git_url}"
username: "${var.github_manifests_username}"
EOL
        secrets = <<EOL
credentials:
  password: {{ .driver.secrets.password | quote }}
EOL
      }
    })
  }
}

resource "humanitec_resource_definition_criteria" "k8s_cluster_git" {
  resource_definition_id = humanitec_resource_definition.k8s_cluster_git.id
  env_type               = var.environment

  force_delete = true
}
