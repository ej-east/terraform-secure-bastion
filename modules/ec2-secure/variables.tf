variable "name_prefix" {
  description = "Prefix for naming"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID where the EC2 instance will be launched"
  type        = string
}

variable "key_name" {
  description = "name of the AWS keypair to use"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "ami_id" {
  description = "AMI ID to use"
  type        = string
  default     = null
}

variable "user_data_file" {
  description = "Path to user data script file"
  type        = string
  validation {
    error_message = "User datafile must exist"
    condition     = fileexists(var.user_data_file)
  }
}

variable "allowed_cidr_blocks" {
  description = "List of CIDR blocks allowed to have access"
  type        = list(string)
  validation {
    condition     = length(var.allowed_cidr_blocks) > 0
    error_message = "At least one CIDR block is required"
  }
}

variable "allowed_ports" {
  description = "List of allowed ports for inbound access"
  type        = list(number)
  default     = [22]
}

variable "encrypt" {
  description = "Add EBS encryption to the aws_instance"
  type        = bool
  default     = true
}

variable "dlm_retain_policy" {
  description = "How many days should we keep the EBS snapshots (in days)"
  type        = number
  default     = 14
  validation {
    error_message = "We need to keep EBS snapshots for 7 days minimum"
    condition     = var.dlm_retain_policy >= 7
  }
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
}
