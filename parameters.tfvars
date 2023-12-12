CustomerID                 = "cl8"
location                   = "eastus"
location2                  = "westus"
environment                = "alz"
laws_sku                   = "PerGB2018"
retention_days             = 90
keyvault_sku               = "standard"
soft_delete_retention_days = 7
account_tier               = "Standard"
account_replication_type   = "LRS"
createalzkv                = true
createauditsta             = true
creatediagsta              = true
createhub1                 = true
createhub2                 = false
create_vms                 = true
create_data_disks          = true
vm_number                  = 2
rsv_sku                    = "Standard"
vault_name                 = "backup"
aut_acc_name               = "automation"
aut_acc_sku                = "Basic"
frontend_name              = "app-LB"
allocation_method          = "Static"
load_balancer_name         = "app_lb"
load_balancer_sku          = "Standard"
private_ip_allocation      = "static"
private_ip                 = "10.46.0.133"
pip_sku                    = "Standard"


data_disks = {
  disk0 = {
    id        = 0
    disk_size = 8
    disk_type = "Standard_LRS"
  }
  disk1 = {
    id        = 1
    disk_size = 8
    disk_type = "Premium_LRS"
  }
  disk2 = {
    id        = 2
    disk_size = 4
    disk_type = "Premium_LRS"
  }
}

cache_mode        = "None"
number_mngd_disks = 3
#########################################Parameters for virtual machine######################################################
vm_size              = "Standard_B2s"
admin_username       = "eitadm"
vm_publisher         = "MicrosoftWindowsServer"
vm_offer             = "WindowsServer"
vm_sku               = "2016-Datacenter"
vm_version           = "latest"
keyvault_secret_name = "Terraform-vm-password"
#########################################Parameters for virtual machine######################################################



address_space_hub1   = ["10.41.0.0/22"]
address_space_hub2   = ["10.42.0.0/22"]
address_space_shared = ["10.45.0.0/22"]
address_app_network  = ["10.46.0.0/22"]

subnets_hub1 = {
  subnet0 = {
    index          = 0
    name           = "ApplicationGateway"
    address_prefix = "10.41.3.160/27"
    security_group = "ApplicationGateway-nsg" //added code for seg inside the subnet map if doesnt work remove the code
    creatensg      = true                     //added code for seg inside the subnet map if doesnt work remove the code 
  }
  subnet1 = {
    index          = 1
    name           = "GatewaySubnet"
    address_prefix = "10.41.3.224/27"
    security_group = "GatewaySubnet-nsg"
    creatensg      = false
  }

  subnet2 = {
    index          = 2
    name           = "FirewallSubnet"
    address_prefix = "10.41.3.0/26"
    security_group = "FirewallSubnet-nsg"
    creatensg      = false
  }

}

subnets_hub2 = {
  subnet0 = {
    index          = 0
    name           = "ApplicationGateway"
    address_prefix = "10.42.3.160/27"
    security_group = "ApplicationGateway-nsg" //added code for seg inside the subnet map if doesnt work remove the code
    creatensg      = true                     //added code for seg inside the subnet map if doesnt work remove the code 
  }
  subnet1 = {
    index          = 1
    name           = "GatewaySubnet"
    address_prefix = "10.42.3.224/27"
    security_group = "GatewaySubnet-nsg"
    creatensg      = false
  }

  subnet2 = {
    index          = 2
    name           = "FirewallSubnet"
    address_prefix = "10.42.3.0/26"
    security_group = "FirewallSubnet-nsg"
    creatensg      = false
  }

}


subnets_shared = {
  subnet0 = {
    index          = 0
    name           = "sharedServicesSubnet"
    address_prefix = "10.45.0.0/25"
    security_group = "sharedServicesSubnet-nsg"
    creatensg      = true
  }

  #   subnet1 = {
  #     index          = 1
  #     name           = "sharedSubnet"
  #     address_prefix = "10.43.0.0/25"
  #     security_group = "sharedSubnet-nsg"
  #     creatensg      = true
  #   }  
}

app_subnets = {
  subnet0 = {
    index          = 0
    name           = "AppSubnet"
    address_prefix = "10.46.0.0/25"
    security_group = "AppSubnet-nsg" //added code for seg inside the subnet map if doesnt work remove the code
    creatensg      = false           //added code for seg inside the subnet map if doesnt work remove the code 
  }
  subnet1 = {
    index          = 1
    name           = "LBsubnet"
    address_prefix = "10.46.0.128/25"
    security_group = "LBsubnet-nsg"
    creatensg      = false
  }

  subnet2 = {
    index          = 2
    name           = "DBSubnet"
    address_prefix = "10.46.3.0/26"
    security_group = "DBSubnet-nsg"
    creatensg      = false
  }

}


# subnets = {
#   subnet0 = {
#     index          = 0
#     name           = "AVDSubnet"
#     address_prefix = "10.41.0.128/25"
#     security_group = "AVDSubnet-nsg"
#     creatensg      = true
#   }
#   subnet1 = {
#     index          = 1
#     name           = "SharedServicesSubnet"
#     address_prefix = "10.41.0.0/25"
#     security_group = "SharedServicesSubnet-nsg"
#     creatensg      = true
#   }

#   subnet2 = {
#     index          = 2
#     name           = "GatewaySubnet"
#     address_prefix = "10.41.3.224/27"
#     security_group = "GatewaySubnet-nsg"
#     creatensg      = false
#   }
#   subnet3 = {
#     index          = 3
#     name           = "DMZSubnet"
#     address_prefix = "10.41.1.0/26"
#     security_group = "DMZSubnet-nsg"
#     creatensg      = true
#   }
#   subnet4 = {
#     index          = 4
#     name           = "FirewallSubnet"
#     address_prefix = "10.41.3.0/26"
#     security_group = "FirewallSubnet-nsg"
#     creatensg      = false
#   }
#   subnet5 = {
#     index          = 5
#     name           = "TestLinkSubnet"
#     address_prefix = "10.41.3.192/27"
#     security_group = "TestLinkSubnet-nsg"
#     creatensg      = true
#   }
#   subnet6 = {
#     index          = 6
#     name           = "ApplicationGateway"
#     address_prefix = "10.41.3.160/27"
#     security_group = "ApplicationGateway-nsg" //added code for seg inside the subnet map if doesnt work remove the code
#     creatensg      = true                     //added code for seg inside the subnet map if doesnt work remove the code 
#   }

# }
