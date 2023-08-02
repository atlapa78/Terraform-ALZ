resource "azurerm_network_interface" "nic" {
  name                = lower("${var.vm_name}-eth0")
  location            = var.location
  resource_group_name = var.rgname
  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "virtual-machine" {
  name                = var.vm_name
  resource_group_name = var.rgname
  location            = var.location
  size                = var.vm_size
  admin_username      = var.admin_username
  admin_password      = random_string.password.result
  network_interface_ids = [
    azurerm_network_interface.nic.id,
  ]
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = var.vm_publisher
    offer     = var.vm_offer
    sku       = var.vm_sku
    version   = var.vm_version
  }
  //depends_on = [azurerm_key_vault.key_vault, azurerm_key_vault_secret.key_vault_secret]
}

//data "azurerm_client_config" "current_config" {}

resource "random_string" "password" {
  length      = 16
  special     = true
  min_upper   = 2
  min_lower   = 2
  min_numeric = 2
  min_special = 2
}


resource "azurerm_key_vault_secret" "key_vault_secret" {
  name         = var.keyvault_secret_name
  value        = random_string.password.result
  key_vault_id = var.keyvault_id
}


