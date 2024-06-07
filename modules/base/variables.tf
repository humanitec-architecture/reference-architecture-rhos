variable "aws_account_id" {
  description = "AWS Account (ID)"
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

variable "basedomain" {
  description = "Base domain"
  type        = string
}

variable "humanitec_org_id" {
  description = "Humanitec Organization ID"
  type        = string
}

variable "humanitec_secret_store_id" {
  description = "Humanitec Secret Store ID"
  type        = string
  default     = "ref-arch"
}
