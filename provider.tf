provider "google" {
  project = var.project_id
  region  = var.region
  #zone        = "europe-west9-a"
}

provider "google-beta" {
  project = var.project_id
}