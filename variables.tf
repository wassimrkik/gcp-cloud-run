variable "SHAREPOINT_CLIENT_ID" {
  type      = string
  sensitive = true
}

variable "SHAREPOINT_SECRET" {
  type      = string
  sensitive = true
}

variable "SHAREPOINT_TENANT_ID" {
  type      = string
  sensitive = true
}

variable "PGUSER" {
  type      = string
  sensitive = true
}

variable "PGPASSWORD" {
  type      = string
  sensitive = true
}

variable "API_KEY" {
  type      = string
  sensitive = true
}

variable "LANGFUSE_SECRET_KEY" {
  type      = string
  sensitive = true
}

variable "ENCRYPTION_KEY" {
  type      = string
  sensitive = true
}

variable "EUROPE_PMC_API_KEY" {
  type      = string
  sensitive = true
}

variable "SEMANTIC_SCHOLAR_API_KEY" {
  type      = string
  sensitive = true
}

variable "AZURE_CLIENT_SECRET" {
  type      = string
  sensitive = true
}

variable "LLAMA_CLOUD_API_KEY" {
  type      = string
  sensitive = true
}

variable "DO_SPACES_SECRET_KEY" {
  type      = string
  sensitive = true
}

variable "DO_SPACES_ACCESS_KEY" {
  type      = string
  sensitive = true
}

variable "AZURE_CLIENT_ID" {
  type      = string
  sensitive = true
}

variable "AZURE_TENANT_ID" {
  type      = string
  sensitive = true
}

variable "project_id" {
  type    = string
  # default = "patricio-poc-1"
  default = "cori-clinical"
}

variable "domain" {
  type    = string
  default = "cori-clinical.com"
}

variable "region" {
  type    = string
  default = "europe-west1"
}