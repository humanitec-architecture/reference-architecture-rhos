# TODO Remove before merge

module "terraform_state_backend" {
  source     = "cloudposse/tfstate-backend/aws"
  version    = "1.1.1"
  namespace  = var.humanitec_org_id
  name       = "ra-rhos-with-rhdh"
  attributes = ["state"]

  terraform_backend_config_file_path = "."
  terraform_backend_config_file_name = "backend.tf"
  force_destroy                      = false
}
