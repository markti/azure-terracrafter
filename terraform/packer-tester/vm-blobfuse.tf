data azurerm_shared_image_version minecraft_blobfuse {
  name                = "latest"
  image_name          = "minecraft-bedrock-local"
  gallery_name        = var.gallery_name
  resource_group_name = var.gallery_resource_group
}

module bedrock_blobfuse {

  source = "../modules/vm/linux-public"

  name                = "fuse${random_string.main.result}"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  subnet_id           = module.network.subnet_id
  vm_image_id         = data.azurerm_shared_image_version.minecraft_blobfuse.id
  ssh_public_key      = tls_private_key.main.public_key_openssh

}

###################
# /etc/smbcredentials/minecraft-fileshare.cred
###################
# username=STORAGE_ACCOUNT_NAME
# password=STORAGE_ACCOUNT_KEY

###################
# /etc/fstab
###################
# //STORAGE_ACCOUNT_NAME.file.core.windows.net/minecraft /mount/STORAGE_ACCOUNT_NAME/minecraft cifs nofail,credentials=/etc/smbcredentials/minecraft-fileshare.cred,serverino,nosharesock,actimeo=30

resource azurerm_virtual_machine_extension blobfuse_cse {

  count = 0

  name                 = "Minecraft-Final-Setup"
  virtual_machine_id   = module.bedrock_blobfuse.id
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.0"

  settings = <<SETTINGS
  {
  "script": "${
      base64encode(
        templatefile("${path.module}/scripts/setup-fileshare.sh", 
          {
            storage_account_name="${azurerm_storage_account.main.name}"
            storage_account_key="${azurerm_storage_account.main.primary_access_key}"
          }
        )
      )
    }"
  }
SETTINGS

}
