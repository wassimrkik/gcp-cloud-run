# ☁️ Cloud Run V2 Terraform Module

This module provisions a fully-featured Google Cloud Run V2 service with optional support for:

- ✅ Secret Manager integration  
- ✅ PostgreSQL (Cloud SQL) with private VPC peering  
- ✅ Load Balancer with Managed SSL  
- ✅ Custom environment configuration via JSON  
- ✅ Public or private access control (IAM-based)

---

## 📦 Features

- Deploys Google Cloud Run V2 service  
- Supports private Cloud SQL connectivity  
- Injects env vars from a JSON file  
- Manages Google Secret Manager secrets per service  
- Grants secret access to the correct service account  
- Creates HTTPS Load Balancer with domain & SSL support  
- Allows optional public access (`allUsers`) or IAM-based  

---

## 🔧 Module Inputs

| Name                | Type           | Description                                                  |
|---------------------|----------------|--------------------------------------------------------------|
| `service-name`      | `string`       | Cloud Run service name                                       |
| `repo-name`         | `string`       | GitHub repository name (for tracking/logging)                |
| `repo-description`  | `string`       | Description of the deployed repo/service                     |
| `region`            | `string`       | GCP region to deploy resources                               |
| `project_id`        | `string`       | GCP project ID                                               |
| `service-account`   | `string`       | Email of the service account to run Cloud Run container      |
| `public_access`     | `bool`         | Allow public (unauthenticated) access                        |
| `limits`            | `bool`         | Enable Cloud Run CPU/memory limits                           |
| `database`          | `bool`         | Enable Cloud SQL backend with private VPC                    |
| `sql_password`      | `string`       | PostgreSQL password for Cloud SQL                            |
| `env_file_override` | `string`       | Optional path to env JSON override file                      |
| `secrets`           | `map(string)`  | Secrets to store in Secret Manager and inject in Cloud Run   |
| `lb_name`           | `string`       | Name of the Load Balancer                                    |
| `domain`            | `string`       | Domain name for HTTPS routing (e.g. `app.example.com`)       |
| `ssl`               | `bool`         | Enable managed SSL certs                                     |

---

## 🛠️ Example Usage

```hcl
module "my_service" {
  source             = "./cloud_run"
  service-name       = "my-service"
  repo-name          = "my-repo"
  repo-description   = "My awesome app"
  region             = var.region
  project_id         = var.project_id
  public_access      = true
  limits             = true
  database           = true
  sql_password       = var.PGPASSWORD
  service-account    = google_service_account.default.email
  env_file_override  = "${path.module}/envs/env_my_service.json"
  secrets = {
    API_KEY         = "abc123"
    ENCRYPTION_KEY  = "secret!"
  }
  lb_name = "my-service"
  domain  = "my-service.${var.domain}"
  ssl     = true
}

## 🔐 Secrets & Env Vars

### 🔸 Secrets

- Passed via `secrets` input map  
- Automatically created in **Secret Manager**  
- Mounted in **Cloud Run** as secure env vars

```hcl
secrets = {
  API_KEY         = "abc123"
  ENCRYPTION_KEY  = "secret!"
}
## 🔸 Env File Override

Use a JSON file to define environment variables:

**Example: `env_my_service.json`**

```json
{
  "NODE_ENV": "production",
  "PORT": "8080"
}
## 🛢️ Cloud SQL (Optional)

Enable by setting `database = true`:

- Creates **PostgreSQL 17** instance with private VPC access  
- Sets up VPC peering (`servicenetworking.googleapis.com`)  
- Creates a private IP range via `google_compute_global_address`  
- Injects connection via `/cloudsql` mount  

---

## 🌐 Load Balancer

This module uses the [`terraform-google-modules/lb-http`](https://github.com/terraform-google-modules/terraform-google-lb-http) to create:

- HTTPS Load Balancer  
- Managed SSL certs for `var.domain`  
- A serverless NEG targeting Cloud Run  

---

## 🔓 Access Control

| Access Type | Controlled By               |
|-------------|-----------------------------|
| Public      | `public_access = true`      |
| Private     | `public_access = false` + IAM |

---

## 📁 Folder Structure Suggestion

```bash
.
├── envs/
│   ├── env_my_service.json
│   ├── env_be.json
│   └── env_addin.json
├── main.tf
├── variables.tf
├── outputs.tf
└── modules/
    └── cloud_run/
        ├── main.tf
        ├── variables.tf
        └── outputs.tf

## 🔑 IAM Permissions Required

Ensure the user or service account running Terraform has the following roles:

- `roles/secretmanager.admin`
- `roles/run.admin`
- `roles/iam.serviceAccountUser`
- `roles/cloudsql.admin`
- `roles/compute.networkAdmin`
- `roles/servicenetworking.networksAdmin`
- `roles/compute.viewer`
- `roles/resourcemanager.projectIamAdmin`

---

## 💡 Tips

- Use `TF_VAR_` prefixed environment variables to inject secrets securely  
  **Example:**
  ```bash
  export TF_VAR_API_KEY=abc123


## 📄 Notes

- Secrets are provisioned as `google_secret_manager_secret` and mounted in Cloud Run
- Secret access is scoped to the Cloud Run service account via IAM
- Database and Load Balancer resources are created conditionally using `count` and `for_each`
