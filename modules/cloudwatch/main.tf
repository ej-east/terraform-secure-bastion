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

resource "aws_cloudwatch_metric_alarm" "memory_usage" {
  alarm_name          = "${var.instance_name}-memory-usage"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = var.evaluation_periods
  metric_name         = "mem_used_percent"
  namespace           = "CWAgent"
  period              = var.alarm_period
  statistic           = "Average"
  threshold           = var.memory_threshold_percent
  alarm_description   = "This metric monitors memory usage"

  dimensions = {
    InstanceId = var.instance_id
  }

  tags = {
    Name        = "${var.instance_name}-memory-alarm"
    Instance    = var.instance_name
    MonitorType = "Memory"
  }
}

resource "aws_cloudwatch_log_metric_filter" "failed_ssh" {
  name           = "${var.instance_name}-failed-ssh"
  log_group_name = "/ec2/secure"
  pattern        = "[Mon, day, timestamp, ip, id, msg1= Failed, msg2= password, ...]"

  metric_transformation {
    name      = "FailedSSHAttempts"
    namespace = "CustomMetrics/${var.instance_name}"
    value     = "1"
  }
}
