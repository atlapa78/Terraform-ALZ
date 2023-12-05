variable "rgname" {
  type        = string
  description = "name of resource group"
}

variable "location" {
  type        = string
  description = "location of the resources"
}

variable "tags_rg" {
  type        = map(any)
  description = "A map of tags to assign to the resource. Allowed values are 'key = value'pairs"
}