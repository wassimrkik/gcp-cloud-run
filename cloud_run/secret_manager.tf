resource "google_secret_manager_secret" "secrets" {
  for_each = var.secrets

  secret_id = each.key
  replication {
    auto {

    }
  }
  depends_on = [google_cloud_run_v2_service.default]
}

resource "google_secret_manager_secret_version" "secret_versions" {
  for_each    = var.secrets
  secret      = google_secret_manager_secret.secrets[each.key].id
  secret_data = each.value
}

resource "google_secret_manager_secret_iam_member" "access" {
  for_each = google_secret_manager_secret.secrets

  secret_id = each.value.id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${google_cloud_run_v2_service.default.template.0.service_account}"
}
