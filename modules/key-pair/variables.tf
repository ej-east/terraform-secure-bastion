variable "tags" {
  description = "Common Tags"
  type = map(string)
}

variable "name_prefix" {
  description = "The name prefix"
  type = string
  validation {
    condition = length(var.name_prefix) > 0
    error_message = "name_prefix can't be empty"
  }
}

variable "create_key" {
  description = "Whether to create a new key pair (true) or use existing (false)"
  type = bool
  default = false
}

variable "existing_key_path" {
  description = "The file path to an existing key"
  type = string
  validation {
    error_message = "If you want to use an existing you you must specify a filepath"
    condition = var.create_key || (var.existing_key_path != null && fileexists(var.existing_key_path))
  }
}

variable "keyname" {
  description = "Default name for pem key"
  type = string
  default = "ec2_priv"
}