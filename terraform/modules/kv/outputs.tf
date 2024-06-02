# Source the output Keyvault ID from the Terraform User's Access Policy to avoid race conditions!
output "id" {
  value = azurerm_key_vault_access_policy.terraform_user.key_vault_id
}