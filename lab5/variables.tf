# variables for port and protocol
variable "env" {
  default = "prod"
}
variable "root_prod_storage_size" {
  type    = number
  default = 20
}
variable "root_default_storage_size" {
  type    = number
  default = 10
}
variable "ssh_port" {
  type    = number
  default = 22
}
variable "app_port" {
  type    = number
  default = 5000
}
variable "http_port" {
  type    = number
  default = 80
}