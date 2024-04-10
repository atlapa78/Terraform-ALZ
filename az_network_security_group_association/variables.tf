variable "subnet_id" {
  type              = string
  description       = "Id of the subnet for the association"
}


variable "nsg_id" {
  type              = string
  description       = "Id of the route table for the association"
}
