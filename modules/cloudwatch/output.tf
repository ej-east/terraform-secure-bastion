output "alarm_arns" {
  description = "List of ARNs of CloudWatch alarms"
  value = {
    cpu         = aws_cloudwatch_metric_alarm.cpu_utilization.arn
    disk        = aws_cloudwatch_metric_alarm.disk_usage.arn
    memory      = aws_cloudwatch_log_metric_filter.memory_threshold_percent.arn
    sshd_failed = aws_cloudwatch_log_metric_filter.failed_ssh.arn

  }
}
