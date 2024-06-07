variable "environment" {
  description = "Environment"
  type        = string
  default     = "development"
}

variable "github_org_id" {
  description = "GitHub org id"
  type        = string
}

variable "github_manifests_repo" {
  description = "GitHub repository for manifests"
  type        = string

  validation {
    condition     = var.github_manifests_repo != null
    error_message = "Required for ArgoCD"
  }
}

variable "github_manifests_username" {
  description = "GitHub username to pull & push manifests"
  type        = string

  validation {
    condition     = var.github_manifests_username != null
    error_message = "Required for ArgoCD"
  }
}

variable "github_manifests_password" {
  description = "GitHub password to pull & push manifests"
  type        = string
  sensitive   = true

  validation {
    condition     = var.github_manifests_password != null
    error_message = "Required for ArgoCD"
  }
}

variable "basedomain" {
  description = "Base domain"
  type        = string
}
