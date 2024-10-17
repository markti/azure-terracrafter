locals {
  ceiling_y = 68 + var.wall_height + 1

  ceiling_positions = flatten([
    for x in range(-5, 0) : [
      for z in range(-15, -10) : {
        x = x
        y = local.ceiling_y
        z = z
      }
    ]
  ])
}

resource "minecraft_block" "ceiling" {
  for_each = { for pos in local.ceiling_positions : "${pos.x}_${pos.y}_${pos.z}" => pos }

  material = var.ceiling_type

  position = {
    x = each.value.x
    y = each.value.y
    z = each.value.z
  }

  depends_on = [minecraft_block.walls]
}
