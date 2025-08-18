resource "aws_cloudwatch_metric_alarm" "cpu_utilization" {
  alarm_name          = "${var.instance_name}-cpu-usage"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = var.evaluation_periods
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = var.alarm_period
  statistic           = "Average"
  threshold           = var.cpu_threshold_percent
  alarm_description   = "This metric monitors CPU utilization"

  dimensions = {
    InstanceId = var.instance_id
  }
  tags = merge(var.tags, {
    Name        = "${var.instance_name}-cpu-alarm"
    Instance    = var.instance_name
    MonitorType = "CPU"
  })
}

resource "aws_cloudwatch_metric_alarm" "disk_usage" {
  alarm_name          = "${var.instance_name}-disk-usage"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = var.evaluation_periods
  metric_name         = "disk_used_percent"
  namespace           = "CWAgent"
  period              = var.alarm_period
  statistic           = "Average"
  threshold           = var.disk_threshold_percent
  alarm_description   = "This metric monitors disl utilization"

  dimensions = {
    device = "xvda1"
    fstype = "xfs"
    path   = "/"
  }
  tags = merge(var.tags, {
    Name        = "${var.instance_name}-cpu-alarm"
    Instance    = var.instance_name
    MonitorType = "Disk"
  })
}
