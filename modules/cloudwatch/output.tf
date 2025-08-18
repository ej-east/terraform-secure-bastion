output "alarm_arns" {
  description = "List of ARNs of CloudWatch alarms"
  value = {
    cpu         = aws_cloudwatch_metric_alarm.cpu_utilization.arn
    disk        = aws_cloudwatch_metric_alarm.disk_usage.arn
    memory      = aws_cloudwatch_metric_alarm.memory_usage.arn
    sshd_failed = aws_cloudwatch_metric_alarm.failed_ssh_alarm.arn

  }
}
