data "azurerm_image" "minecraft" {
  name                = "${var.image_name}-${var.image_version}"
  resource_group_name = var.gallery_resource_group
}

resource "azurerm_user_assigned_identity" "minecraft" {
  count = var.minecraft_server_enabled ? 1 : 0

  name                = "mi-minecraft-server"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location

}

module "minecraft_server" {

  count = var.minecraft_server_enabled ? 1 : 0

  source = "./modules/vm/linux-public"

  location            = var.location
  name                = "${var.name}local"
  resource_group_name = azurerm_resource_group.main.name
  subnet_id           = module.network.subnet_id
  vm_image_id         = data.azurerm_image.minecraft.id
  ssh_public_key      = tls_private_key.main.public_key_openssh
  managed_identity_id = azurerm_user_assigned_identity.minecraft[0].id

}

resource "random_password" "minecraft" {
  length  = 8
  special = false
  upper   = true
  lower   = true
}

locals {
  post_provisioning = templatefile("${path.module}/scripts/minecraft-postprov.sh",
    {
      minecraft_password = "${random_password.minecraft.result}"
    }
  )
}

resource "azurerm_virtual_machine_extension" "local_cse" {

  count = var.minecraft_server_enabled ? 1 : 0

  name                 = "Minecraft-Final-Setup"
  virtual_machine_id   = module.minecraft_server[0].id
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.0"

  settings = <<SETTINGS
 {
   "script": "${base64encode(local.post_provisioning)}"
 }
SETTINGS

}

resource "random_string" "minecraft_storage" {
  length  = 8
  special = false
  upper   = false
  lower   = false
}

resource "azurerm_storage_account" "minecraft" {
  name                     = "stmc${random_string.minecraft_storage.result}"
  resource_group_name      = azurerm_resource_group.main.name
  location                 = azurerm_resource_group.main.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "drop" {
  name                  = "drop"
  storage_account_name  = azurerm_storage_account.minecraft.name
  container_access_type = "private"
}

resource "azurerm_role_assignment" "minecraft_storage" {

  count = var.minecraft_server_enabled ? 1 : 0

  scope                = azurerm_storage_account.minecraft.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_user_assigned_identity.minecraft[0].principal_id
}
