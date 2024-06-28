# Configures ArgoCD https://github.com/argoproj/argo-cd

locals {
  argocd_manifests                              = "${path.module}/argocd"
  argocd_manifests_repo_credentials_secret_name = "manifests-repo-credentials"
}

resource "kubernetes_namespace_v1" "argocd" {
  metadata {
    name = "argocd"
  }

  lifecycle {
    ignore_changes = [
      metadata[0].annotations["openshift.io/sa.scc.mcs"],
      metadata[0].annotations["openshift.io/sa.scc.supplemental-groups"],
      metadata[0].annotations["openshift.io/sa.scc.uid-range"],
    ]
  }
}

resource "kubernetes_secret_v1" "argocd_manifests_repo_credentials" {
  metadata {
    name      = local.argocd_manifests_repo_credentials_secret_name
    namespace = kubernetes_namespace_v1.argocd.id
  }

  data = {
    username = var.github_manifests_username
    password = var.github_manifests_password
  }
}


# TODO This should be replaced with better wait-for logic
resource "time_sleep" "argocd_operator_ready" {
  depends_on = [
    kubernetes_manifest.argocd_operator_group,
    kubernetes_manifest.argocd_operator_subscription,
  ]

  create_duration = "30s"
}


resource "kubernetes_manifest" "argocd_instance" {
  manifest = yamldecode(templatefile("${local.argocd_manifests}/argocd-instance.yaml", {
    NAMESPACE               = kubernetes_namespace_v1.argocd.metadata[0].name,
    REPO_URL                = local.git_url,
    REPO_CREDENTIALS_SECRET = local.argocd_manifests_repo_credentials_secret_name,
  }))

  field_manager {
    force_conflicts = true
  }

  depends_on = [
    kubernetes_secret_v1.argocd_manifests_repo_credentials,
    time_sleep.argocd_operator_ready,
  ]
}

# TODO This should be replaced with better wait-for logic
resource "time_sleep" "argocd_instance_ready" {
  depends_on = [kubernetes_manifest.argocd_instance]

  create_duration  = "10s"
  destroy_duration = "30s" # Some time is required to cleanup argocd application created by the set
}

resource "kubernetes_manifest" "argocd_applicationset" {
  manifest = yamldecode(templatefile("${local.argocd_manifests}/argocd-applicationset.yaml", {
    NAMESPACE = kubernetes_namespace_v1.argocd.metadata[0].name,
    REPO_URL  = local.git_url,
  }))

  field_manager {
    force_conflicts = true
  }

  depends_on = [
    time_sleep.argocd_instance_ready,
  ]
}
