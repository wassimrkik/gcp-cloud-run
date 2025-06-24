resource "google_cloud_run_v2_service" "default" {
  name                = var.service-name
  location            = "europe-west9"
  deletion_protection = false
  ingress             = "INGRESS_TRAFFIC_ALL"

  template {
    containers {
      image = "us-docker.pkg.dev/cloudrun/container/hello"

      dynamic "resources" {
        for_each = var.limits ? [1] : []
        content {
          limits = {
            cpu    = "2"
            memory = "1024Mi"
          }
        }
      }
    }
  }
}

data "google_iam_policy" "noauth" {
  binding {
    role = "roles/run.invoker"
    members = [
      "allUsers",
    ]
  }
}

resource "google_cloud_run_service_iam_policy" "noauth" {
  count = var.public_access == true ? 1 : 0
  location    = "europe-west9"
  service     = google_cloud_run_v2_service.default.name
  policy_data = data.google_iam_policy.noauth.policy_data
}