# resource "google_artifact_registry_repository" "my-repo" {
#   repository_id = var.repo-name
#   description   = var.repo-description
#   location      = var.region
#   format        = "DOCKER"
# }