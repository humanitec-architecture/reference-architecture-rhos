resource "aws_iam_user" "humanitec_ecr_pull" {
  name = "humanitec_ecr_pull"
}

resource "aws_iam_user_policy_attachment" "humanitec_ecr_pull" {
  user = aws_iam_user.humanitec_ecr_pull.name
  # https://docs.aws.amazon.com/AmazonECR/latest/userguide/security-iam-awsmanpol.html#security-iam-awsmanpol-AmazonEC2ContainerRegistryReadOnly
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_iam_access_key" "humanitec_ecr_pull" {
  user = aws_iam_user.humanitec_ecr_pull.name

  # Ensure that the policy is not deleted before the access key
  depends_on = [aws_iam_user_policy_attachment.humanitec_ecr_pull]
}

locals {
  ecr_pull_secrets = {
    aws-access-key-id     = aws_iam_access_key.humanitec_ecr_pull.id
    aws-secret-access-key = aws_iam_access_key.humanitec_ecr_pull.secret
  }

  ecr_pull_secret_refs = {
    for key, value in local.ecr_pull_secrets : key => {
      ref     = aws_secretsmanager_secret.ecr_pull[key].name
      store   = var.humanitec_secret_store_id
      version = aws_secretsmanager_secret_version.ecr_pull[key].version_id
    }
  }
}

resource "aws_secretsmanager_secret" "ecr_pull" {
  for_each = local.ecr_pull_secrets
  name     = "humanitec-ecr-pull-secret-${each.key}"
}

resource "aws_secretsmanager_secret_version" "ecr_pull" {
  for_each = local.ecr_pull_secrets

  secret_id     = aws_secretsmanager_secret.ecr_pull[each.key].id
  secret_string = each.value
}

locals {
  regcred_config_res_id = "regcred"
  regcred_secret_name   = "regcred"
}

resource "humanitec_resource_definition" "default_config_regcred" {
  id          = "default-regcred-config"
  name        = "default-regcred-config"
  type        = "config"
  driver_type = "humanitec/template"

  driver_inputs = {
    secret_refs = jsonencode({
      "AWS_ACCESS_KEY_ID"     = local.ecr_pull_secret_refs["aws-access-key-id"]
      "AWS_SECRET_ACCESS_KEY" = local.ecr_pull_secret_refs["aws-secret-access-key"]
    })

    values_string = jsonencode({
      secret_name    = local.regcred_secret_name
      server         = "${data.aws_caller_identity.current.account_id}.dkr.ecr.${var.aws_region}.amazonaws.com"
      aws_account_id = data.aws_caller_identity.current.account_id
      aws_region     = var.aws_region
      namespace      = "$${resources[\"k8s-namespace.default#k8s-namespace\"].outputs.namespace}"

      templates = {
        manifests = <<EOL
# The manifests template creates the Kubernetes Secret
# which can then be used in the workload "imagePullSecrets"
ecr-registry-helper-secret.yaml:
  data:
    apiVersion: v1
    kind: Secret
    metadata:
      name: ecr-registry-helper
    stringData:
      AWS_ACCESS_KEY_ID: {{ .driver.secrets.AWS_ACCESS_KEY_ID | quote }}
      AWS_SECRET_ACCESS_KEY: {{ .driver.secrets.AWS_SECRET_ACCESS_KEY | quote }}
      AWS_ACCOUNT: {{ .driver.values.aws_account_id | quote }}
  location: namespace
ecr-registry-helper-configmap.yaml:
  data:
    apiVersion: v1
    kind: ConfigMap
    metadata:
      name: ecr-registry-helper
    data:
      AWS_REGION: {{ .driver.values.aws_region | quote }}
      DOCKER_SECRET_NAME: {{ .driver.values.secret_name | quote }}
      NAMESPACE_NAME: {{ .driver.values.namespace | quote }}
  location: namespace
ecr-registry-helper-job.yaml:
  data:
    apiVersion: batch/v1
    kind: Job
    metadata:
      name: ecr-registry-helper-initial
    spec:
      template:
        spec:
          serviceAccountName: ecr-registry-helper
          containers:
          - name: ecr-registry-helper
            image: ghcr.io/humanitec-architecture/aws-ecr-credentials-refresh
            envFrom:
              - secretRef:
                  name: ecr-registry-helper
              - configMapRef:
                  name: ecr-registry-helper
          restartPolicy: Never
  location: namespace
ecr-registry-helper-cronjob.yaml:
  data:
    apiVersion: batch/v1
    kind: CronJob
    metadata:
      name: ecr-registry-helper
    spec:
      schedule: "0 */10 * * *"
      successfulJobsHistoryLimit: 3
      suspend: false
      jobTemplate:
        spec:
          template:
            spec:
              serviceAccountName: ecr-registry-helper
              containers:
              - name: ecr-registry-helper
                image: ghcr.io/humanitec-architecture/aws-ecr-credentials-refresh
                envFrom:
                  - secretRef:
                      name: ecr-registry-helper
                  - configMapRef:
                      name: ecr-registry-helper
              restartPolicy: Never
  location: namespace
ecr-registry-helper-serviceaccount.yaml:
  data:
    apiVersion: v1
    kind: ServiceAccount
    metadata:
      name: ecr-registry-helper
  location: namespace
ecr-registry-helper-role.yaml:
  data:
    apiVersion: rbac.authorization.k8s.io/v1
    kind: Role
    metadata:
      name: ecr-registry-helper
    rules:
    - apiGroups: [""]
      resources: ["secrets"]
      resourceNames: [{{ .driver.values.secret_name | quote }}]
      verbs: ["delete"]
    - apiGroups: [""]
      resources: ["secrets"]
      verbs: ["create"]
  location: namespace
ecr-registry-helper-rolebinding.yaml:
  data:
    kind: RoleBinding
    apiVersion: rbac.authorization.k8s.io/v1
    metadata:
      name: ecr-registry-helper
    subjects:
    - kind: ServiceAccount
      name: ecr-registry-helper
      apiGroup: ""
    roleRef:
      kind: Role
      name: ecr-registry-helper
      apiGroup: ""
  location: namespace
EOL
        outputs   = <<EOL
secret_name: {{ .driver.values.secret_name }}
EOL
      }
    })
  }
}

resource "humanitec_resource_definition_criteria" "default_config_regcred" {
  resource_definition_id = humanitec_resource_definition.default_config_regcred.id
  env_type               = var.environment
  res_id                 = local.regcred_config_res_id
}

resource "humanitec_resource_definition" "default_workload" {
  driver_type = "humanitec/template"
  id          = "default-workload"
  name        = "default-workload"
  type        = "workload"

  driver_inputs = {
    values_string = jsonencode({
      templates = {
        outputs = <<EOL
update:
- op: add
  path: /spec/imagePullSecrets
  value:
    - name: ${local.regcred_secret_name}
EOL
        # Value should be: - name: $${resources["config.default#${local.regcred_config_res_id}"].outputs.secret_name}
      }
    })
  }

  provision = {
    "config.default#${local.regcred_config_res_id}" = {
      is_dependent     = false
      match_dependents = false
    }
  }
}

resource "humanitec_resource_definition_criteria" "default_workload" {
  resource_definition_id = humanitec_resource_definition.default_workload.id
  env_type               = var.environment
}
