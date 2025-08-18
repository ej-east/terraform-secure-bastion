variable "instance_name" {
  description = "The name of the AWS instance"
  type        = string
}

variable "instance_id" {
  description = "AWS instance ID to monitor"
  type        = string
}

variable "evaluation_periods" {
  description = "Number of periods to evaluate before alarming"
  type        = number
  default     = 2
}

variable "alarm_period" {
  description = "Period in seconds for alarm evaluation"
  type        = number
  default     = 300
}

variable "cpu_threshold_percent" {
  description = "CPU threshold to trigger alarm"
  type        = number
  default     = 80
}

variable "disk_threshold_percent" {
  description = "Disk threshold to trigger alarm"
  type        = number
  default     = 80
}

variable "memory_threshold_percent" {
  description = "Memory threshold to trigger alarm"
  type        = number
  default     = 85
}

variable "failed_ssh_threshold" {
  description = "Failed SSH threshold to trigger alarm"
  type        = number
  default     = 3
}

variable "aws_sns_topic_arn" {
  description = "The ARN of the SNS topic that you wish to trigger on alarm"
  type        = string
  default     = ""
}

variable "log_group_prefix" {
  description = "Log Group Prefix"
  type        = string
  default     = "ec2"
}

variable "log_group_failed_ssh" {
  description = "The log group for failed SSH"
  type        = string
  default     = "secure"
}


variable "tags" {
  description = "List of tags"
  type        = map(string)
}
