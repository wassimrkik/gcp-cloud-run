# 🚀 Cloud Run Terraform Module

This Terraform module simplifies the deployment of [Google Cloud Run](https://cloud.google.com/run) services on Google Cloud Platform (GCP). It automatically sets up an Artifact Registry for storing container images and deploys a Cloud Run service with configurable access and resource limits.

---

## 📦 Features

- Creates an Artifact Registry repository for container images
- Deploys a Cloud Run service from a specified image
- Optionally enables public access
- Optionally sets CPU and memory resource limits

---

## 📘 Usage

```hcl
module "cloud-run" {
  source = "./cloud_run"

  repo-name        = "my-repo"                        # Name of the Artifact Registry repo
  repo-description = "Container repo for my service" # Description of the repo
  repo-location    = "europe-west9"                  # GCP region for the repo and Cloud Run

  service-name     = "my-cloud-run-service"          # Name of the Cloud Run service

  # Optional values
  public_access    = true                            # (Default: false) If true, allows unauthenticated access
  limits           = true                            # (Default: true) If true, sets resource limits
}
