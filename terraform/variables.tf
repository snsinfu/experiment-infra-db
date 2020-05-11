variable "server_hostname" {
  type    = string
  default = "data"
}

variable "server_location" {
  type    = string
  default = "fsn1"
}

variable "server_type" {
  type    = string
  default = "cx11"
}

variable "server_image" {
  type    = string
  default = "freebsd-12.1"
}

variable "volume_id" {
  type = string
}

variable "admin_user" {
  type = string
}

variable "admin_password_hash" {
  type    = string
  default = "*"
}

variable "admin_public_keys" {
  type = list(string)
}
