# resource "google_cloud_run_service_iam_policy" "private" {
#   location    = var.region
#   project     = var.project_id
#   service     = "be-poc-cori"
#   policy_data = data.google_iam_policy.private.policy_data
#   depends_on  = [module.cori-be]
# }
# data "google_iam_policy" "private" {
#   binding {
#     role = "roles/run.invoker"
#     members = [
#       "serviceAccount:${google_service_account.default.email}",
#     ]
#   }
# }

resource "google_service_account" "default" {
  account_id   = "cloud-run-interservice-id"
  description  = "Identity used by a public Cloud Run service to call private Cloud Run services."
  display_name = "cloud-run-interservice-id"
}

resource "google_project_iam_member" "grant_secret_accessor_public" {
  project = var.project_id
  role    = "roles/secretmanager.secretAccessor"
  member  = "serviceAccount:${google_service_account.default.email}"
}

# resource "google_project_iam_member" "grant_secret_accessor" {
#   project = var.project_id
#   role    = "roles/secretmanager.secretAccessor"
#   member  = "serviceAccount:${google_service_account.secret-accessor.email}"
# }

# resource "google_service_account" "secret-accessor" {
#   account_id   = "secret-accessor"
#   description  = "Identity used to access secrets"
#   display_name = "secret-accessor"
# }

# resource "null_resource" "wait_for_iam_propagation" {
#   provisioner "local-exec" {
#     command = "sleep 15"
#   }

#   triggers = {
#     always = timestamp() # ensures it runs every time
#   }

#   depends_on = [google_project_iam_member.grant_secret_accessor_public]
# }