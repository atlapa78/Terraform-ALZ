# variable rt_associations {
#     type        = any
#     description = "Tuple containing the association between subnet and route table"
# }

variable "subnet_id" {
  type              = string
  description       = "Id of the subnet for the association"
}


variable "rt_id" {
  type              = string
  description       = "Id of the route table for the association"
}
