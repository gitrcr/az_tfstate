# modules/tfstate/variables.tf

variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "storage_account_name" {
  type = string
}

variable "container_name" {
  type    = string
  default = "tfstate"
}

variable "tags" {
  type    = map(string)
  default = {}
}   