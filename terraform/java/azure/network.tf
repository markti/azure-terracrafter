
module "network" {

  source = "./modules/network/bastion"

  name                = random_string.main.result
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location

}

resource "azurerm_network_security_rule" "minecraft" {
  name                        = "minecraft-port"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "${var.minecraft_port}-${var.minecraft_port}"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.main.name
  network_security_group_name = module.network.nsg_name
}

resource "azurerm_network_security_rule" "rcon" {
  name                        = "rcon-port"
  priority                    = 101
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "${var.rcon_port}-${var.rcon_port}"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.main.name
  network_security_group_name = module.network.nsg_name
}
