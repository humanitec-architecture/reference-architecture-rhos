output "humanitec_secret_store_id" {
  description = "Humanitec secret store id"
  value       = humanitec_secretstore.main.id
}

output "humanitec_imagepullsecret_config_res_id" {
  description = "Humanitec imagepullsecret config resource id"
  value       = local.imagepullsecret_config_res_id
}
