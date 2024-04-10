output "subnets" {
  value          =  tolist([for sub in values(azurerm_subnet.az_subnet) : sub.id])
}