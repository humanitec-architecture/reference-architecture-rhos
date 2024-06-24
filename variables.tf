variable "humanitec_org_id" {
  description = "Humanitec Organization ID"
  type        = string
  default     = null
}

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

variable "with_argocd" {
  description = "Deploy ArgoCD"
  type        = bool
  default     = false
}

variable "github_manifests_username" {
  description = "GitHub username to pull & push manifests (required for ArgoCD)"
  type        = string
  default     = null
}

variable "github_manifests_password" {
  description = "GitHub password  to pull & push manifests (required for ArgoCD)"
  type        = string
  default     = null
}

variable "github_manifests_repo" {
  description = "GitHub repository for manifests (required for ArgoCD)"
  type        = string
  default     = "humanitec-app-manifests"
}
