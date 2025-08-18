variable "aws_region" {
  description = "The main AWS region"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "The current project name"
  type        = string
}

variable "environment" {
  description = "Current working environment"
  type        = string
  default     = "dev"
}

variable "allowed_cidr_blocks" {
  description = "The CIDRs allowed to interact with bastion host"
  type        = list(string)
  validation {
    error_message = "Cannot be all"
    condition     = var.allowed_cidr_blocks != ["0.0.0.0/0"]
  }
}

variable "bastion_email_subscriber_one" {
  description = "Email address of who to send the CloudWatch alarms"
  type        = string
  validation {
    error_message = "Must be a valid email address"
    condition     = can(regex("/^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$/", var.bastion_email_subscriber_one))
  }
}
