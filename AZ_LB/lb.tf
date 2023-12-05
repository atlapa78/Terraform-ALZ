resource "azurerm_lb" "az_lb" {
  name                = var.az_lb_name
  location            = var.location
  resource_group_name = var.rgname
  sku                 = var.lb_sku
  tags                = var.tags_rsrc

  frontend_ip_configuration {
    name = var.frontend_name
    //public_ip_address_id = var.public_ip_address_id
    subnet_id                     = var.subnet_lb_id
    private_ip_address_allocation = var.private_ip_allocation
    private_ip_address            = var.private_ip_allocation == "static" ? var.private_ip : null
  }
}