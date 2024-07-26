terraform {
  required_version = ">= 1.0.0"

  backend "s3" {
    region         = "eu-central-1"
    bucket         = "htc-demo-41-ra-rhos-with-rhdh-state"
    key            = "terraform.tfstate"
    dynamodb_table = "htc-demo-41-ra-rhos-with-rhdh-state-lock"
    profile        = ""
    role_arn       = ""
    encrypt        = "true"
  }
}
