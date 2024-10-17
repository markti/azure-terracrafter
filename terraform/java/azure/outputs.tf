
output "public_ip_address" {
  value = can(module.minecraft_server[0].public_ip_address) ? module.minecraft_server[0].public_ip_address : null
}
output "minecraft_password" {
  value     = random_password.minecraft.result
  sensitive = true
}
