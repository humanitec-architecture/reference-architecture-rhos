terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.17"
    }
    github = {
      source  = "integrations/github"
      version = "~> 5.38"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.13"
    }
    humanitec = {
      source  = "humanitec/humanitec"
      version = "~> 1.0"
    }
    kubectl = {
      source  = "alekc/kubectl"
      version = "~> 2.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.30"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.5"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
  }
  required_version = ">= 1.3.0"
}

provider "humanitec" {
  org_id = var.humanitec_org_id
}

provider "github" {
  owner = var.github_org_id
}

provider "aws" {
  region              = var.aws_region
  allowed_account_ids = [var.aws_account_id]
}

provider "kubectl" {
  config_path    = var.kubeconfig
  config_context = var.kubectx
}

provider "kubernetes" {
  config_path    = var.kubeconfig
  config_context = var.kubectx
}

provider "helm" {
  kubernetes {
    config_path    = var.kubeconfig
    config_context = var.kubectx
  }
}
