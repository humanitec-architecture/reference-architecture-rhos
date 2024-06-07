# Installs the humanitec-operator into the cluster

# More details https://developer.humanitec.com/integration-and-extensions/humanitec-operator/overview/

resource "kubernetes_namespace" "humanitec_operator" {
  metadata {
    labels = {
      "app.kubernetes.io/name"     = "humanitec-operator"
      "app.kubernetes.io/instance" = "humanitec-operator"
    }

    name = "humanitec-operator-system"
  }

  lifecycle {
    ignore_changes = [
      metadata[0].annotations["openshift.io/sa.scc.mcs"],
      metadata[0].annotations["openshift.io/sa.scc.supplemental-groups"],
      metadata[0].annotations["openshift.io/sa.scc.uid-range"],
    ]
  }
}


resource "tls_private_key" "operator_private_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "humanitec_key" "operator_public_key" {
  key = tls_private_key.operator_private_key.public_key_pem
}

resource "kubernetes_secret" "humanitec_operator" {
  metadata {
    name      = "humanitec-operator-private-key"
    namespace = kubernetes_namespace.humanitec_operator.id
  }

  data = {
    privateKey              = tls_private_key.operator_private_key.private_key_pem
    humanitecOrganisationID = var.humanitec_org_id
  }
}

resource "kubernetes_secret" "humanitec_operator_awssm_credentials" {
  metadata {
    name      = "awssm-credentials"
    namespace = kubernetes_namespace.humanitec_operator.id
  }

  data = {
    access_key_id     = aws_iam_access_key.humanitec_operator.id,
    secret_access_key = aws_iam_access_key.humanitec_operator.secret
  }
}


resource "helm_release" "humanitec_operator" {
  name      = "humanitec-operator"
  namespace = kubernetes_namespace.humanitec_operator.id

  repository = "oci://ghcr.io/humanitec/charts"
  chart      = "humanitec-operator"
  version    = "0.2.4"
  wait       = true
  timeout    = 300

  depends_on = [
    humanitec_key.operator_public_key,
    kubernetes_secret.humanitec_operator,
    kubernetes_secret.humanitec_operator_awssm_credentials
  ]
}

# User by the Humanitec Operator to access the AWS Secrets Manager

resource "aws_iam_user" "humanitec_operator" {
  name = "humanitec_svc_rhos_operator"
}

data "aws_iam_policy_document" "humanitec_operator" {
  version = "2012-10-17"

  statement {
    actions = [
      "secretsmanager:GetSecretValue",
      "secretsmanager:CreateSecret",
      "secretsmanager:DeleteSecret",
      "secretsmanager:PutSecretValue"
    ]

    resources = ["arn:aws:secretsmanager:${var.aws_region}:${var.aws_account_id}:secret:*"]
  }
}

resource "aws_iam_policy" "humanitec_operator" {
  name        = "humanitec-operator"
  description = "Humanitec Operator EKS service account policy"
  policy      = data.aws_iam_policy_document.humanitec_operator.json
}

resource "aws_iam_user_policy_attachment" "humanitec_operator" {
  user       = aws_iam_user.humanitec_operator.name
  policy_arn = aws_iam_policy.humanitec_operator.arn
}

resource "aws_iam_access_key" "humanitec_operator" {
  user = aws_iam_user.humanitec_operator.name

  # Ensure that the policy is not deleted before the access key
  depends_on = [aws_iam_user_policy_attachment.humanitec_operator]
}

# Configure a primary secret store

resource "kubectl_manifest" "humanitec_operator_secret_store" {
  yaml_body = templatefile("${path.module}/manifests/humanitec-secret-store.yaml", {
    SECRET_STORE_ID        = var.humanitec_secret_store_id,
    SECRETS_MANAGER_REGION = var.aws_region,
    SECRET_NAME            = kubernetes_secret.humanitec_operator_awssm_credentials.metadata[0].name,
  })
  override_namespace = kubernetes_namespace.humanitec_operator.id
  wait               = true

  depends_on = [
    helm_release.humanitec_operator
  ]
}

resource "humanitec_secretstore" "main" {
  id      = var.humanitec_secret_store_id
  primary = true
  awssm = {
    region = var.aws_region
  }
}
