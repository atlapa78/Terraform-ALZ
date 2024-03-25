variable "location" {
  type        = string
  description = "location of resources"
}

variable "rgname" {
  type        = string
  description = "Nameg of the resource group"
}

variable "subnet_id" {
  type        = string
  description = "ID of the subnet to allocate the vm nic"

}

# variable "keyvault_id" {
#   type        = string
#   description = "ID of the keyvault used for the genrated password"
# }

variable "vm_name" {
  type        = string
  description = "virtual machine name"
}

variable "vm_size" {
  type        = string
  description = "virtual machine size"
}

variable "admin_username" {
  type        = string
  description = "username"
  default     = "azureuser"
}

variable "vm_publisher" {
  type        = string
  description = "Virtual machine publisher"
}

variable "vm_offer" {
  type        = string
  description = "Virtual machine offer"
}

variable "vm_sku" {
  type        = string
  description = "Virtual machine sku"
}

variable "vm_version" {
  type        = string
  description = "Virtual machine os version"
  default     = "latest"
}


variable "vm_password" {
  type        = string
  description = "virtual machine password"
  default     = "vmpassword"
}

variable "tags_rsrc" {
  type        = map(any)
  description = "A map of tags to assign to the resource. Allowed values are 'key = value'pairs"
}
