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

variable "res_def_name" {
  description = "k8s-cluster resource definition name"
  type        = string
  default     = "ref-arch"
}
