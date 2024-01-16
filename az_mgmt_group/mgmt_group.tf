resource "azurerm_management_group" "mgmt_group" {
  display_name = var.mgmt_display
  parent_management_group_id = var.parent_mgmt_group_id != null ? var.parent_mgmt_group_id : null
  //subscription_ids = [ "${var.subscription_id != null ? var.subscription_id : ""}"  ]
}