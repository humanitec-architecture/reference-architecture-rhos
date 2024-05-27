terraform {
  required_version = ">= 1.3.0"
}


variable "credentials_file" {
  description = "Path to the GitHub App credentials file"
  type        = string
}

locals {
  credentials    = jsondecode(file(var.credentials_file))
  app_id         = local.credentials["appId"]
  client_id      = local.credentials["clientId"]
  client_secret  = local.credentials["clientSecret"]
  private_key    = local.credentials["privateKey"]
  webhook_secret = local.credentials["webhookSecret"]
  webhook_url    = local.credentials["webhookUrl"]
}

output "app_id" {
  value = local.app_id
}

output "client_id" {
  value = local.client_id
}

output "client_secret" {
  value = local.client_secret
}

output "private_key" {
  value = local.private_key
}

output "webhook_secret" {
  value = local.webhook_secret
}

output "webhook_url" {
  value = local.webhook_url
}
