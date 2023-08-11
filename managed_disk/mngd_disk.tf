resource "azurerm_managed_disk" "disk" {
  name                 = var.disk_name
  location             = var.location
  resource_group_name  = var.rgname
  storage_account_type = var.disk_type
  create_option        = "Empty"
  disk_size_gb         = var.disk_size
}