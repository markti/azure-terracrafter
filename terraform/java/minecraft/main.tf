
# -5, 67, -15
/*
resource "minecraft_block" "stone" {
  material = "minecraft:stone"

  position = {
    x = -5
    y = 68
    z = -15
  }

  depends_on = [azurerm_network_security_rule.rcon]
}*/


module "house" {
  source = "./modules/house"

  start_x = 70
  start_y = 71
  start_z = -28

  house_width  = 5
  house_length = 5
  wall_height  = 3

  ceiling_type = "minecraft:gold_block"
  wall_type    = "minecraft:gold_block"
  floor_type   = "minecraft:gold_block"

}


# minecraft:gold_block
