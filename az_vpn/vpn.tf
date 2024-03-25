

resource "azurerm_virtual_network_gateway" "vpn" {
  name                            = var.vpn_name
  location                        = var.location
  resource_group_name             = var.rgname
  type                            = var.vng_type
  vpn_type                        = var.vpn_type

  active_active                   = false
  enable_bgp                      = false
  sku                             = var.vpn_sku

  ip_configuration {
    name                          = "vnetGatewayConfig"
    public_ip_address_id          = var.public_ip_address_id
    private_ip_address_allocation = var.private_ip_address_allocation
    subnet_id                     = var.subnet_id
  }

  tags                            = var.tags_rsrc
}