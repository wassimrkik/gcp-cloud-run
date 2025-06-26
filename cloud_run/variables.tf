variable "repo-name" {
  type = string
}
variable "repo-description" {
  type = string
}

variable "service-name" {

}

variable "public_access" {
  type    = bool
  default = false
}

variable "limits" {
  default = true
  type    = bool
}

variable "database_name" {
  default = null
}
variable "database" {
  default = false
  type    = bool
}

variable "region" {
  default = "europe-west9"
}

variable "ssl" {
  type = bool
  default = true
}

variable "domain" {
  type = string
}

variable "lb_name" {
  type = string
}

variable "project_id" {
  default = "patricio-poc-1"
}