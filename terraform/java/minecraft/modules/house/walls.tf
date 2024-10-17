locals {
  wall_positions_x = flatten([
    for y in range(var.start_y + 1, var.start_y + var.wall_height + 1) : [
      for x in range(var.start_x, var.start_x + var.house_width) : [
        { x = x, y = y, z = var.start_z },                       # North wall
        { x = x, y = y, z = var.start_z + var.house_length - 1 } # South wall
      ]
    ]
  ])
}
locals {
  wall_positions_z = flatten([
    for y in range(var.start_y + 1, var.start_y + var.wall_height + 1) : [
      for z in range(var.start_z, var.start_z + var.house_length) : [
        { x = var.start_x, y = y, z = z },                      # West wall
        { x = var.start_x + var.house_width - 1, y = y, z = z } # East wall
      ]
    ]
  ])
}
locals {
  wall_positions = distinct(concat(local.wall_positions_x, local.wall_positions_z))
}

resource "minecraft_block" "walls" {
  for_each = { for pos in local.wall_positions : "${pos.x}_${pos.y}_${pos.z}" => pos }

  material = "minecraft:gold_block"

  position = {
    x = each.value.x
    y = each.value.y
    z = each.value.z
  }

  depends_on = [minecraft_block.floor]
}
