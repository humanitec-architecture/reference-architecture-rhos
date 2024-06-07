variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "humanitec_org_id" {
  description = "Humanitec Organization ID"
  type        = string
}

variable "humanitec_ci_service_user_token" {
  description = "Humanitec CI Service User Token"
  type        = string
  sensitive   = true
}

variable "github_org_id" {
  description = "GitHub org id"
  type        = string

  validation {
    condition     = var.github_org_id != null
    error_message = "GitHub org id must not be empty"
  }
}
