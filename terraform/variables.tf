variable "location" {
  type    = string
  default = "eastus"
}

variable "company" {
  type    = string
  default = "degreed"
}

variable "workload" {
  type    = string
  default = "wapps"
}

variable "environment" {
  type    = string
  default = "dev01"
}

variable "name_suffix" {
  type = string
  default = "tobi"
}

variable "sql_admin_user" {
  type    = string
  default = "sqladminuser"
}

variable "sql_admin_password" {
  type      = string
  sensitive = true
}

variable "db_name" {
  type    = string
  default = "degreed-wapps-prod-db"
}
