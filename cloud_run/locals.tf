locals {
  # Extract type from name (assumes format like "cori-be")
  service_type = regex("[^-]+-(.*)", var.service-name)[0]

  # Build the file path dynamically
  env_file_path = var.env_file_override != "" ? var.env_file_override : "${path.root}/env_${local.service_type}.json"

  # Load the file only if it exists, else empty map
  raw_env = fileexists(local.env_file_path) ? jsondecode(file(local.env_file_path)) : {}

  # Convert to Cloud Run env format
  env_list = [
    for k, v in local.raw_env : {
      name  = k
      value = v
    }
  ]
}


locals {
  secret_env_vars = [
    for key in keys(var.secrets) : {
      name   = key
      secret = key
    }
  ]
}