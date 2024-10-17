terraform {
  required_providers {
    minecraft = {
      source  = "HashiCraft/minecraft"
      version = "~> 0.1.1"
    }
  }
}

provider "minecraft" {
  address  = "${var.minecraft_server}:${var.rcon_port}"
  password = var.rcon_password
}
