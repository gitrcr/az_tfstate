variable "resource_group_name" {
  description = "The name of the resource group for the lab environment."
  type        = string
}

variable "location" {
  description = "The location of the resource group for the lab environment."
  type        = string
}

variable "tags" {
  type    = map(string)
  default = {}
}



