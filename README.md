# ☁️ Cloud Run Terraform Setup for Cori POC

This Terraform configuration deploys three services (`FE`, `BE`, and `Add-in`) on **Google Cloud Run** using a reusable `cloud_run` module. It also manages IAM roles, secret access, and private/public access settings.

---

## 📦 Modules Overview

### 🔹 `module.cori-fe`
- Frontend service (`fe-poc-cori`)
- Publicly accessible via domain: `front.${var.domain}`
- Uses service account: `google_service_account.default.email`
- Loads environment variables from: `envs/env_fe.json`
- Injects secrets from: `local.fe_service_secrets`

### 🔹 `module.cori-be`
- Backend service (`be-poc-cori`)
- **Private Cloud Run service**
- Attached to Cloud SQL (`database = true`)
- Uses dedicated service account: `google_service_account.secret-accessor.email`
- Loads envs from: `envs/env_be.json`
- Injects secrets from: `local.be_service_secrets`
- Grants frontend service account access via IAM

### 🔹 `module.cori-addin`
- Add-in frontend (`addin-poc-cori`)
- Publicly accessible via domain: `addin.${var.domain}`
- Uses `google_service_account.default.email`
- Loads envs from: `envs/env_addin.json`
- Injects secrets from: `local.addin_service_secrets`

---

## 🔐 IAM Setup

- `google_service_account.default`: Shared service account for public services (FE, Add-in)
- `google_service_account.secret-accessor`: Used for accessing secrets in private BE
- `google_cloud_run_service_iam_policy.private`: Grants `fe` access to invoke private `be`
- Project-level roles are granted:
  - `roles/secretmanager.secretAccessor` to both service accounts

---

## 📁 Secrets & Env Vars

- Secrets are defined per service in `local.*_service_secrets` and passed to each module.
- An `env_file_override` JSON is used to provide fixed or override env vars for each service.
- Secrets are provisioned to **Secret Manager** and mounted in Cloud Run with clean names.

---

## ⏳ IAM Propagation Wait

The `null_resource.wait_for_iam_propagation` is used to delay Cloud Run service deployment until IAM role bindings are fully propagated.

---

## 🚀 Usage

### 1. Export required secrets

```bash
export TF_VAR_PGPASSWORD="your-db-password"
export TF_VAR_API_KEY="your-api-key"
# ...and all other required TF_VAR_*
