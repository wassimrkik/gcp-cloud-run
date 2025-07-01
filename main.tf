module "cori-fe" {
  source            = "./cloud_run"
  repo-name         = "poc-fe"
  repo-description  = "repo for poc fe "
  region            = "europe-west1"
  service-name      = "fe-poc-cori"
  public_access     = true
  limits            = false
  lb_name           = "front"
  domain            = "front.cloudwaves.net"
  service-account   = google_service_account.default.email
  env_file_override = "${path.module}/envs/env_fe.json"
}

module "cori-be" {
  source            = "./cloud_run"
  repo-name         = "poc-be"
  repo-description  = "repo for poc be"
  region            = "europe-west1"
  service-name      = "be-poc-cori"
  public_access     = false
  limits            = false
  database          = true
  database_name     = "be-sql"
  lb_name           = "back"
  domain            = "back.cloudwaves.net"
  service-account   = null
  sql_password      = "testtesttest"
  env_file_override = "${path.module}/envs/env_be.json"
}

module "cori-addin" {
  source            = "./cloud_run"
  repo-name         = "poc-add-in"
  repo-description  = "repo for poc word addin "
  region            = "europe-west1"
  service-name      = "addin-poc-cori"
  public_access     = true
  limits            = false
  lb_name           = "addin"
  domain            = "addin.cloudwaves.net"
  service-account   = google_service_account.default.email
  env_file_override = "${path.module}/envs/env_addin.json"
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
  location    = "europe-west1"
  project     = "patricio-poc-1"
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
