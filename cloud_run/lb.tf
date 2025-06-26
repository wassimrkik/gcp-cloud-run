resource "google_compute_region_network_endpoint_group" "serverless_neg" {
  name                  = "serverless-neg-${google_cloud_run_v2_service.default.name}"
  network_endpoint_type = "SERVERLESS"
  region                = var.region
  cloud_run {
    service = google_cloud_run_v2_service.default.name
  }
}

module "lb-http" {
  source  = "terraform-google-modules/lb-http/google//modules/serverless_negs"
  version = "~> 12.0"

  name    = var.lb_name
  project = var.project_id

  ssl                             = var.ssl
  managed_ssl_certificate_domains = [var.domain]
  https_redirect                  = var.ssl
  labels                          = { "example-label" = "cloud-run-example" }

  backends = {
    default = {
      description = null
      groups = [
        {
          group = google_compute_region_network_endpoint_group.serverless_neg.id
        }
      ]
      enable_cdn = false

      iap_config = {
        enable = false
      }
      log_config = {
        enable = false
      }
    }
  }
}