variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "cluster_res_def_name" {
  description = "Cluster Resource Definition Name"
  type        = string
  default     = "ref-arch"
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
