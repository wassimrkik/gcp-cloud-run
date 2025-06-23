module "cori" {
  source           = "./cloud_run"
  repo-name        = "poc"
  repo-description = "repo for poc"
  repo-location    = "europe"
  service-name     = "poc-cori"
}