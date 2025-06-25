module "cori-fe" {
  source           = "./cloud_run"
  repo-name        = "poc-fe"
  repo-description = "repo for poc fe "
  repo-location    = "europe"
  service-name     = "fe-poc-cori"
  public_access    = true
  limits           = false
}

module "cori-be" {
  source           = "./cloud_run"
  repo-name        = "poc-be"
  repo-description = "repo for poc be"
  repo-location    = "europe"
  service-name     = "be-poc-cori"
  public_access    = false
  limits           = false
  database         = true
  database_name    = "be-sql"
}

module "cori-addin" {
  source           = "./cloud_run"
  repo-name        = "poc-add-in"
  repo-description = "repo for poc word addin "
  repo-location    = "europe"
  service-name     = "addin-poc-cori"
  public_access    = true
  limits           = false
}
