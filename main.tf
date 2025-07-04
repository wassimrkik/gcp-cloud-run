module "cori-fe" {
  source            = "./cloud_run"
  repo-name         = "poc-fe"
  repo-description  = "repo for poc fe "
  region            = var.region
  service-name      = "fe-poc-cori"
  public_access     = true
  limits            = false
  lb_name           = "app"
  domain            = "app.${var.domain}"
  service-account   = google_service_account.default.email
  env_file_override = "${path.module}/envs/env_fe.json"
  secrets           = local.fe_service_secrets
  project_id        = var.project_id
  depends_on        = [null_resource.wait_for_iam_propagation]
  container_port    = 3000
}

module "cori-be" {
  source            = "./cloud_run"
  repo-name         = "poc-be"
  repo-description  = "repo for poc be"
  region            = var.region
  service-name      = "be-poc-cori"
  public_access     = true
  limits            = true
  database          = true
  database_name     = "be-sql"
  lb_name           = "api"
  domain            = "api.${var.domain}"
  service-account   = google_service_account.default.email
  sql_password      = var.PGPASSWORD
  env_file_override = "${path.module}/envs/env_be.json"
  secrets           = local.be_service_secrets
  project_id        = var.project_id
  container_port    = 8000
}

module "cori-addin" {
  source            = "./cloud_run"
  repo-name         = "poc-add-in"
  repo-description  = "repo for poc word addin "
  region            = var.region
  service-name      = "addin-poc-cori"
  public_access     = true
  limits            = false
  lb_name           = "office"
  domain            = "office.${var.domain}"
  service-account   = google_service_account.default.email
  env_file_override = "${path.module}/envs/env_addin.json"
  secrets           = local.addin_service_secrets
  project_id        = var.project_id
  depends_on        = [null_resource.wait_for_iam_propagation]
  container_port    = 443
}

