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

resource "kubernetes_config_map" "rhdh_app_configmap" {
  metadata {
    name      = "app-config-rhdh"
    namespace = kubernetes_namespace_v1.rhdh.id
  }

  data = {
    "app-config.yaml" = <<-EOT
      app:
        title: Red Hat Developer Hub
        baseUrl: https://backstage-developer-hub-rhdh.${var.basedomain}
      backend:
        auth:
          keys:
            - secret: ${resource.kubernetes_secret_v1.rhdh_secrets.metadata[0].name}
        baseUrl: https://backstage-developer-hub-rhdh.${var.basedomain}
        cors:
          origin: https://backstage-developer-hub-rhdh.${var.basedomain}
      catalog:
        rules:
          - allow: [Component, System, Group, Resource, Location, Template, API, User, Domain, Type]
        locations:
          - type: url
            target: https://github.com/humanitec-architecture/backstage-catalog-templates/blob/main/podinfo/template.yaml
          - type: url
            target: https://github.com/humanitec-architecture/backstage-catalog-templates/blob/main/node-service/template.yaml
          - type: url
            target: https://github.com/humanitec-architecture/reference-architecture-rhos/blob/main/backstage-templates/quarkus-todo/template.yaml
      dynamicPlugins:
        # See https://github.com/janus-idp/backstage-showcase/blob/main/showcase-docs/dynamic-plugins.md#frontend-layout-configuration
        frontend:
          humanitec.backstage-plugin:
            mountPoints:
              - mountPoint: entity.page.overview/cards
                importName: HumanitecCardComponent
                config:
                  layout:
                    gridColumn:
                      lg: '5 / -1'
                      md: '3 / -1'
                      xs: '1 / -1'
                  if:
                    allOf:
                      - isKind: component
            scaffolderFieldExtensions:
              - importName: ValidateHumanitecAppIDFieldExtension
      humanitec:
        orgId: ${var.humanitec_org_id}
        token: ${var.humanitec_ci_service_user_token} # without Bearer
        cloudProvider: aws
        githubOrgId: ${var.github_org_id}
      auth:
        environment: production
        providers:
          github:
            production:
              clientId: ${var.github_app_client_id}
              clientSecret: ${var.github_app_client_secret}
              signIn:
                resolvers:
                  - resolver: usernameMatchingUserEntityName
                    dangerouslyAllowSignInWithoutUserInCatalog: true
      integrations:
        github:
          - host: github.com
            apps:
              - appId: ${var.github_app_id}
                clientId: ${var.github_app_client_id}
                clientSecret: ${var.github_app_client_secret}
                webhookUrl: ${var.github_webhook_url}
                webhookSecret: ${var.github_webhook_secret}
                privateKey: |
                  ${replace(var.github_app_private_key, "\n", "\n            ")}
      signInPage: github
    EOT
  }

  depends_on = [
    kubernetes_namespace_v1.rhdh
  ]
}

resource "kubernetes_config_map" "dynamic_plugin_config_rhdh" {
  metadata {
    name      = "dynamic-plugin-config-rhdh"
    namespace = kubernetes_namespace_v1.rhdh.id
  }

  data = {
    "dynamic-plugins.yaml" = <<-EOT
      includes:
        - dynamic-plugins.default.yaml
      plugins:
        - # update using: npm view @humanitec/backstage-plugin-scaffolder-backend-module-dynamic
          package: '@humanitec/backstage-plugin-scaffolder-backend-module-dynamic@0.4.0'
          integrity: 'sha512-sn6PgR0oCix/Nd0MXLoQ5SW00rF+SNmXArNuH/4dns5zLBN8iXXIhwLh8mIEKu7kI1P9pe/WYhGcA1GNSHCO2A=='
          pluginConfig: {}
        - # update using: npm view @humanitec/backstage-plugin-dynamic
          package: '@humanitec/backstage-plugin-dynamic@0.8.0'
          integrity: 'sha512-y3Cfy/+EkjW9hYqg6KOgRJ1mEobjppE1nkSj3cIBHFH1t5JXhqSE2OOxDzxdqvRdApk3e/JufEgTRn1MpcAxhg=='
          pluginConfig: {}
        - # update using: npm view @humanitec/backstage-plugin-backend-dynamic
          package: '@humanitec/backstage-plugin-backend-dynamic@0.7.0'
          integrity: 'sha512-zzrNbXvB1BVa/z1jWZQwFH90bXvNM5by1MSj7dZZ5MlcftB6D/G10RYvHar4QjsNx+o6klio5I32yLX6vwOYHA=='
          pluginConfig: {}
        - # update using: npm view @backstage/plugin-scaffolder-backend-module-github
          package: '@backstage/plugin-scaffolder-backend-module-github@0.6.1'
          integrity: 'sha512-B1lKoeEZlEz0uFs2LB5p+W2pinDUuLbbtDAV7m8KvAkim6bw7KJ/LB4ibXZHyCRa/nH4Gsgjnb/cTwemSpEveg=='
          pluginConfig: {}
        - package: './dynamic-plugins/dist/backstage-plugin-catalog-backend-module-github-dynamic'
          disabled: false
          pluginConfig:
            catalog:
              providers:
                github:
                  organization: "${var.github_org_id}"
                  schedule:
                    frequency: { minutes: 1 }
                    timeout: { seconds: 45 }
                    initialDelay: { seconds: 10 }
        - package: './dynamic-plugins/dist/backstage-plugin-catalog-backend-module-github-org-dynamic'
          disabled: false
          pluginConfig:
            catalog:
              providers:
                githubOrg:
                  id: "${var.github_org_id}"
                  githubUrl: "https://github.com"
                  orgs: [ "${var.github_org_id}" ]
                  schedule:
                    frequency: { minutes: 1 }
                    timeout: { seconds: 45 }
                    initialDelay: { seconds: 10 }
    EOT
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
    kubernetes_config_map.rhdh_app_configmap,
    kubernetes_config_map.dynamic_plugin_config_rhdh,
    kubernetes_secret_v1.rhdh_github_secrets,
    kubernetes_secret_v1.rhdh_secrets
  ]
}
