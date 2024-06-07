
# Used to access the OpenShift cluster
resource "kubernetes_namespace_v1" "humanitec_system" {
  metadata {
    name = "humanitec-system"
  }

  lifecycle {
    ignore_changes = [
      metadata[0].annotations["openshift.io/sa.scc.mcs"],
      metadata[0].annotations["openshift.io/sa.scc.supplemental-groups"],
      metadata[0].annotations["openshift.io/sa.scc.uid-range"],
    ]
  }
}

resource "kubernetes_service_account_v1" "humanitec" {
  metadata {
    name      = "humanitec"
    namespace = kubernetes_namespace_v1.humanitec_system.id
  }

  lifecycle {
    ignore_changes = [
      image_pull_secret,
      secret,
    ]
  }

  automount_service_account_token = false
}

resource "kubernetes_secret_v1" "humanitec_service_account" {
  metadata {
    annotations = {
      "kubernetes.io/service-account.name" = kubernetes_service_account_v1.humanitec.metadata[0].name
    }

    name      = "humanitec-service-account-token"
    namespace = kubernetes_namespace_v1.humanitec_system.id
  }

  type                           = "kubernetes.io/service-account-token"
  wait_for_service_account_token = true

  depends_on = [
    # Ensure we don't loose access before the secret is deleted on teardown
    kubernetes_cluster_role_binding_v1.humanitec_cluster_admin
  ]
}

resource "kubernetes_cluster_role_binding_v1" "humanitec_cluster_admin" {
  metadata {
    name = "humanitec-cluster-admin"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }

  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account_v1.humanitec.metadata[0].name
    namespace = kubernetes_service_account_v1.humanitec.metadata[0].namespace
  }
}

## Resource definitions for k8s cluster
resource "humanitec_resource_definition" "k8s_cluster_driver" {
  driver_type = "humanitec/k8s-cluster"
  id          = var.res_def_name
  name        = var.res_def_name
  type        = "k8s-cluster"

  driver_inputs = {
    values_string = jsonencode({
      "loadbalancer" = "router-default.${var.basedomain}"
      "cluster_data" = {
        "server"                   = var.apiserver
        "insecure-skip-tls-verify" = true
      }
    }),
    secrets_string = jsonencode({
      "credentials" = {
        "token" = kubernetes_secret_v1.humanitec_service_account.data["token"]
      }
    })
  }
}

resource "humanitec_resource_definition_criteria" "k8s_cluster_driver" {
  resource_definition_id = humanitec_resource_definition.k8s_cluster_driver.id
  env_type               = var.environment

  force_delete = true
}
