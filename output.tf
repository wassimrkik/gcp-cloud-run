output "cloud_run_be" {
  value = module.cori-be.cloud_run_url
}

output "cloud_run_fe" {
  value = module.cori-fe.cloud_run_url
}

output "cloud_run_add" {
  value = module.cori-addin.cloud_run_url
}

output "connection_name" {
  value = module.cori-be.connection_name
}