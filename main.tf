module "cori-fe" {
  source           = "./cloud_run"
  repo-name        = "poc-fe"
  repo-description = "repo for poc fe "
  region           = "europe-west1"
  service-name     = "fe-poc-cori"
  public_access    = true
  limits           = false
  lb_name          = "front"
  domain           = "front.cloudwaves.net"
}

module "cori-be" {
  source           = "./cloud_run"
  repo-name        = "poc-be"
  repo-description = "repo for poc be"
  region           = "europe-west1"
  service-name     = "be-poc-cori"
  public_access    = false
  limits           = false
  database         = true
  database_name    = "be-sql"
  lb_name          = "back"
  domain           = "back.cloudwaves.net"
}

module "cori-addin" {
  source           = "./cloud_run"
  repo-name        = "poc-add-in"
  repo-description = "repo for poc word addin "
  region           = "europe-west1"
  service-name     = "addin-poc-cori"
  public_access    = true
  limits           = false
  lb_name          = "addin"
  domain           = "addin.cloudwaves.net"
}
