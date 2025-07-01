provider "google" {
  project = "cori-clinical"
  region  = "europe-west1"
  #zone        = "europe-west9-a"
}

provider "google-beta" {
  project = "cori-clinical"
}