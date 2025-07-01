output "cloud_run_url" {
  value = google_cloud_run_v2_service.default.urls
}

output "connection_name" {
  value = length(google_sql_database_instance.instance) > 0 ? google_sql_database_instance.instance[0].connection_name : ""
}