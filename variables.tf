variable "aws_account_id" {
  description = "AWS Account (ID) to use"
  type        = string
}

variable "kubeconfig" {
  description = "Path to your kubeconfig file"
  type        = string
}

variable "kubectx" {
  description = "The context to use from your kubeconfig to connect Terraform providers to the cluster"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "environment" {
  description = "Environment"
  type        = string
  default     = "development"
}

variable "apiserver" {
  description = "The API server URL of your OpenShift cluster"
  type        = string
}

variable "basedomain" {
  description = "Base domain"
  type        = string
}

variable "with_backstage" {
  description = "Deploy Backstage"
  type        = bool
  default     = false
}

variable "with_rhdh" {
  description = "Deploy Red Hat Developer Hub"
  type        = bool
  default     = false
}

variable "github_org_id" {
  description = "GitHub org id (required for Backstage and RHDH)"
  type        = string
  default     = null
}

variable "humanitec_org_id" {
  description = "Humanitec Organization ID (required for Backstage and RHDH)"
  type        = string
  default     = null
}

variable "humanitec_ci_service_user_token" {
  description = "Humanitec CI Service User Token (required for Backstage and RHDH)"
  type        = string
  sensitive   = true
  default     = null
}
