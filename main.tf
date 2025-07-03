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
  limits            = false
  database          = true
  database_name     = "be-sql"
  lb_name           = "api"
  domain            = "api.${var.domain}"
  service-account   = google_service_account.secret-accessor.email
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

data "google_iam_policy" "private" {
  binding {
    role = "roles/run.invoker"
    members = [
      "serviceAccount:${google_service_account.default.email}",
    ]
  }
}

resource "google_cloud_run_service_iam_policy" "private" {
  location    = var.region
  project     = var.project_id
  service     = "be-poc-cori"
  policy_data = data.google_iam_policy.private.policy_data
  depends_on  = [module.cori-be]
}

resource "google_service_account" "default" {
  depends_on   = [module.cori-be]
  account_id   = "cloud-run-interservice-id"
  description  = "Identity used by a public Cloud Run service to call private Cloud Run services."
  display_name = "cloud-run-interservice-id"
}

resource "google_project_iam_member" "grant_secret_accessor_public" {
  project = var.project_id
  role    = "roles/secretmanager.secretAccessor"
  member  = "serviceAccount:${google_service_account.default.email}"
}

resource "google_project_iam_member" "grant_secret_accessor" {
  project = var.project_id
  role    = "roles/secretmanager.secretAccessor"
  member  = "serviceAccount:${google_service_account.secret-accessor.email}"
}

resource "google_service_account" "secret-accessor" {
  account_id   = "secret-accessor"
  description  = "Identity used to access secrets"
  display_name = "secret-accessor"
}

resource "null_resource" "wait_for_iam_propagation" {
  provisioner "local-exec" {
    command = "sleep 15"
  }

  triggers = {
    always = timestamp() # ensures it runs every time
  }

  depends_on = [google_project_iam_member.grant_secret_accessor_public]
}