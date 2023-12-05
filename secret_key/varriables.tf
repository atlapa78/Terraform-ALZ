variable "keyvault_secret_name" {
  type        = string
  description = "name for the secret key used for vm password"
}

variable "key_vault_id" {
  type        = string
  description = "id of the keyvault used to store the secret key"
}

variable "tags_rsrc" {
  type        = map(any)
  description = "A map of tags to assign to the resource. Allowed values are 'key = value'pairs"
}