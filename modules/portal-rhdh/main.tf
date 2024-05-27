locals {
  devhub_manifests = "${path.module}/devhub"

}

resource "kubernetes_namespace_v1" "rhdh" {
  metadata {
    name = "rhdh"
  }

  lifecycle {
    ignore_changes = [
      metadata[0].annotations["openshift.io/sa.scc.mcs"],
      metadata[0].annotations["openshift.io/sa.scc.supplemental-groups"],
      metadata[0].annotations["openshift.io/sa.scc.uid-range"],
    ]
  }
}

resource "kubernetes_secret_v1" "rhdh_github_secrets" {
  metadata {
    name      = "github-secrets"
    namespace = kubernetes_namespace_v1.rhdh.id
  }

  data = {
    GITHUB_ORG_ID             = var.github_org_id
    GITHUB_APP_CLIENT_ID      = var.github_app_client_id
    GITHUB_APP_CLIENT_SECRET  = var.github_app_client_secret
    GITHUB_APP_APP_ID         = var.github_app_id
    GITHUB_APP_WEBHOOK_URL    = var.github_webhook_url
    GITHUB_APP_WEBHOOK_SECRET = var.github_webhook_secret
    GITHUB_APP_PRIVATE_KEY    = var.github_app_private_key
  }
}

resource "random_bytes" "backstage_service_to_service_auth_key" {
  length = 24
}

resource "kubernetes_secret_v1" "rhdh_secrets" {
  metadata {
    name      = "rhdh-secrets"
    namespace = kubernetes_namespace_v1.rhdh.id
  }

  data = {
    BACKEND_SECRET   = random_bytes.backstage_service_to_service_auth_key.base64
    basedomain       = var.basedomain
    HUMANITEC_ORG_ID = var.humanitec_org_id
    HUMANITEC_TOKEN  = var.humanitec_ci_service_user_token
  }
}

resource "kubernetes_manifest" "rhdh_app_configmap" {
  manifest = yamldecode(file("${local.devhub_manifests}/rhdh-app-configmap.yaml"))

  field_manager {
    force_conflicts = true
  }

  depends_on = [
    kubernetes_namespace_v1.rhdh
  ]
}

resource "kubernetes_manifest" "rhdh_dynamic_plugins_configmap" {
  manifest = yamldecode(file("${local.devhub_manifests}/rhdh-dynamic-plugins-configmap.yaml"))

  field_manager {
    force_conflicts = true
  }

  depends_on = [
    kubernetes_namespace_v1.rhdh
  ]
}

resource "kubernetes_manifest" "rhdh_instance" {
  manifest = yamldecode(file("${local.devhub_manifests}/rhdh-instance.yaml"))

  depends_on = [
    kubernetes_manifest.rhdh_operator_group,
    kubernetes_manifest.rhdh_operator_subscription,
    kubernetes_manifest.rhdh_app_configmap,
    kubernetes_manifest.rhdh_dynamic_plugins_configmap,
    kubernetes_secret_v1.rhdh_github_secrets,
    kubernetes_secret_v1.rhdh_secrets
  ]
}
