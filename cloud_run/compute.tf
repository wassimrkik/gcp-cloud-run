resource "google_cloud_run_v2_service" "default" {
  name                = var.service-name
  location            = var.region
  deletion_protection = false
  ingress             = "INGRESS_TRAFFIC_ALL"
  depends_on = [ google_secret_manager_secret.secrets, google_secret_manager_secret_version.secret_versions ]
  template {
    service_account = var.service-account
    dynamic "volumes" {
      for_each = var.database ? [1] : []
      content {
        name = "cloudsql"
        cloud_sql_instance {
          instances = [google_sql_database_instance.instance[0].connection_name]
        }
      }
    }
    containers {
      image = "us-docker.pkg.dev/cloudrun/container/hello"
      dynamic "env" {
        for_each = local.env_list
        content {
          name  = env.value.name
          value = env.value.value
        }
      }
      dynamic "volume_mounts" {
        for_each = var.database ? [1] : []
        content {
          name       = "cloudsql"
          mount_path = "/cloudsql"
        }
      }
      dynamic "env" {
        for_each = local.secret_env_vars
        content {
          name = env.value.name
          value_source {
            secret_key_ref {
              secret  = env.value.secret
              version = "latest"
            }
          }
        }
      }
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
  count       = var.public_access == true ? 1 : 0
  location    = var.region
  service     = google_cloud_run_v2_service.default.name
  policy_data = data.google_iam_policy.noauth.policy_data
}
