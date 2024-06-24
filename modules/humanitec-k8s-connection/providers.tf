terraform {
  required_providers {
    humanitec = {
      source  = "humanitec/humanitec"
      version = "~> 1.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.30"
    }
  }
  required_version = ">= 1.3.0"
}
