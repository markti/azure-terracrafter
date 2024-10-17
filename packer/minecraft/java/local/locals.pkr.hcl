locals {
  execute_command    = "chmod +x {{ .Path }}; {{ .Vars }} sudo -E sh '{{ .Path }}'"
  service_name       = "mcjava"
  server_folder_name = "minecraft_java"
}