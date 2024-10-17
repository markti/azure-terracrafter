source "azure-arm" "vm" {
  subscription_id    = var.subscription_id
  use_azure_cli_auth = true

  location                          = var.primary_location
  managed_image_name                = "${var.image_name}-${var.image_version}"
  managed_image_resource_group_name = var.gallery_resource_group
  communicator                      = "ssh"
  os_type                           = "Linux"
  image_publisher                   = "Canonical"
  image_offer                       = "0001-com-ubuntu-server-focal"
  image_sku                         = "20_04-lts"
  vm_size                           = var.vm_size
  allowed_inbound_ip_addresses      = [var.agent_ipaddress]

}