output "alarm_arns" {
  description = "List of ARNs of CloudWatch alarms"
  value = {
    cpu  = aws_cloudwatch_metric_alarm.cpu_utilization.arn
    disk = aws_cloudwatch_metric_alarm.disk_usage.arn
  }
}
