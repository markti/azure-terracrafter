locals {
  floor_positions = flatten([
    for x in range(var.start_x, var.start_x + var.house_width) : [
      for z in range(var.start_z, var.start_z + var.house_length) : {
        x = x
        y = var.start_y
        z = z
      }
    ]
  ])
}

resource "minecraft_block" "floor" {
  for_each = { for pos in local.floor_positions : "${pos.x}_${pos.y}_${pos.z}" => pos }

  material = var.floor_type

  position = {
    x = each.value.x
    y = each.value.y
    z = each.value.z
  }
}
