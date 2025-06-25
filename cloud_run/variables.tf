variable "repo-name" {
  type = string
}
variable "repo-description" {
  type = string
}

variable "repo-location" {
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