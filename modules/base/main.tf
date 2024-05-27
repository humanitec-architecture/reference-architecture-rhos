# RHOS reference architecture

locals {
  admin_policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

# Current AWS Account ID
data "aws_caller_identity" "current" {}

# User for Humanitec to access the EKS cluster

resource "aws_iam_user" "humanitec_svc" {
  name = "humanitec_svc_rhos"
}

resource "aws_iam_user_policy_attachment" "humanitec_svc" {
  user       = aws_iam_user.humanitec_svc.name
  policy_arn = local.admin_policy_arn
}

resource "aws_iam_access_key" "humanitec_svc" {
  user = aws_iam_user.humanitec_svc.name

  # Ensure that the policy is not deleted before the access key
  depends_on = [aws_iam_user_policy_attachment.humanitec_svc]
}

resource "humanitec_registry" "ref-arc-ecr" {
  id        = "ref-arch-ecr"
  registry  = "${data.aws_caller_identity.current.account_id}.dkr.ecr.${var.aws_region}.amazonaws.com"
  type      = "amazon_ecr"
  enable_ci = false
  creds = {
    username = aws_iam_access_key.humanitec_svc.id
    password = aws_iam_access_key.humanitec_svc.secret
  }
}

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
  id          = var.cluster_res_def_name
  name        = var.cluster_res_def_name
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
}

resource "humanitec_resource_definition" "k8s_namespace" {
  driver_type = "humanitec/echo"
  id          = "default-namespace"
  name        = "default-namespace"
  type        = "k8s-namespace"

  driver_inputs = {
    values_string = jsonencode({
      "namespace" = "$${context.app.id}-$${context.env.id}"
    })
  }
}

resource "humanitec_resource_definition_criteria" "k8s_namespace" {
  resource_definition_id = humanitec_resource_definition.k8s_namespace.id
}

# We need this ingress over the HT default because RHOS will only create
# the route if the ingress class is openshift_default
resource "humanitec_resource_definition" "rhos_ingress" {
  driver_type = "humanitec/ingress"
  id          = "rhos-ingress"
  name        = "rhos-ingress"
  type        = "ingress"

  driver_inputs = {
    values_string = jsonencode({
      "ingress_class" = "openshift_default"
    })
  }
}

resource "humanitec_resource_definition_criteria" "rhos_ingress" {
  resource_definition_id = humanitec_resource_definition.rhos_ingress.id
  env_type               = var.environment
}
