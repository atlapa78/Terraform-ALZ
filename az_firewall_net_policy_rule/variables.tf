variable "az_fw_policy_rule_name" {
  type        = string
  description = "The name which should be used for this Firewall Policy Rule Collection Group."
}

variable "fw_policy_id" {
  type        = string
  description = "ID for the Azure Firewall Policy"
}

# variable "location" {
#   type        = string
#   description = "location of the resources"
# }

variable "ntwk_rules_data" {
  type        = any
  description = "Variable used for the network, application or nat rules"
}

variable "priority_group_rule" {
    type            = number
    description     = "Used to define the priority of the collection rule"
}

variable "az_fw_policy_net_rule_name" {
  type        = string
  description = "Name for the resource group for the Azure Firewall Policy"
}


variable "az_fw_policy_net_rule_action" {
  type        = string
  description = "The action to take for the application rules in this collection. Possible values are Allow and Deny."
}

variable "priority_net_rule" {
    type            = number
    description     = "Used to define the priority of the collection rule"
}