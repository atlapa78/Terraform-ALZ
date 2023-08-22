variable "disk_id" {
  type        = string
  description = "id of the managed disk"
}

variable "vm_id" {
  type        = string
  description = "id of the virtual machine"
}

variable "lun_id" {
  type        = string
  description = "number of lun for the managed disk"
}

variable "caching" {
  type        = string
  description = "Specifies the caching requirements for this Managed Data Disk. Possible values include: None, ReadOnly and ReadWrite"
}