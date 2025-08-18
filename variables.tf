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

variable "backend_bucket_name" {
  description = "Name of the bucket to terraform store state"
  type        = string
}
variable "backend_bucket_key" {
  description = "The path where the terraform state is written to [in the bucket]"
  type        = string
}
