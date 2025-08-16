variable "aws_region" {
  description = "The main AWS region"
  type = string
  default = "us-east-1"
}

variable "project_name" {
  description = "The current project name"
  type = string
}

variable "environment" {
  description = "Current working environment"
  type = string
  default = "dev"
}