data "google_compute_network" "default" {
  name = "default"
}

resource "google_compute_global_address" "private_ip_address" {
  count         = var.database ? 1 : 0
  name          = "private-ip-address-${var.service-name}"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = data.google_compute_network.default.self_link
}


resource "google_service_networking_connection" "private_vpc_connection" {
  count                   = var.database ? 1 : 0
  network                 = data.google_compute_network.default.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = var.database ? [google_compute_global_address.private_ip_address[0].name] : []
}


resource "google_sql_database_instance" "instance" {
  count            = var.database ? 1 : 0
  name             = "cloudrun-sql"
  region           = var.region
  database_version = "POSTGRES_17"

  settings {
    edition = "ENTERPRISE"
    tier    = "db-f1-micro"

    ip_configuration {
      ipv4_enabled                                  = false
      private_network                               = data.google_compute_network.default.self_link
      enable_private_path_for_google_cloud_services = true
    }

  }

  deletion_protection = false
  depends_on          = [google_service_networking_connection.private_vpc_connection, google_compute_global_address.private_ip_address]
}

resource "google_sql_user" "user" {
  count      = var.database ? 1 : 0
  name       = "pguser"
  instance   = google_sql_database_instance.instance[0].name
  password   = var.sql_password
  depends_on = [google_sql_database_instance.instance]
}
