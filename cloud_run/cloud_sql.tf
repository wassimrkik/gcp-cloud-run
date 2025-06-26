resource "google_sql_database_instance" "instance" {
  count            = var.database ? 1 : 0
  name             = "cloudrun-sql"
  region           = var.region
  database_version = "POSTGRES_17"

  settings {
    edition = "ENTERPRISE"
    tier    = "db-f1-micro"
  }

  deletion_protection = false
}