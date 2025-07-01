terraform {
  backend "gcs" {
    bucket = "cori-terraform-tfstate"
    prefix = "terraform/cori-state"
  }
}
