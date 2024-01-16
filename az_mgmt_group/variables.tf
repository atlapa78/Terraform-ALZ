variable "mgmt_display" {
   type        = string
   description = "The display name of the management group"
}

# variable "subscription_id" {
#   type         = string
#   description = "A list of Subscription GUIDs which should be assigned to the Management Group."
#   default = null
# }

variable "parent_mgmt_group_id" {
  type         = string
  description  = " (Optional) The ID of the Parent Management Group."
  default      = null
}