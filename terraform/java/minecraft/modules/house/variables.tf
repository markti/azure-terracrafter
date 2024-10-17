variable "start_x" {
  description = "The starting X-coordinate for the house."
  type        = number
}
variable "start_y" {
  description = "The starting Y-coordinate (ground level) for the house."
  type        = number
}
variable "start_z" {
  description = "The starting Z-coordinate for the house."
  type        = number
}
variable "floor_type" {
  type = string
}
variable "wall_type" {
  type = string
}
variable "ceiling_type" {
  type = string
}
variable "house_width" {
  type    = number
  default = 5
}
variable "house_length" {
  type    = number
  default = 5
}
variable "wall_height" {
  type    = number
  default = 5
}
