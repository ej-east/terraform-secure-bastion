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
  alarm_actions       = var.aws_sns_topic_arn != "" ? [var.aws_sns_topic_arn] : []

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
  alarm_description   = "This metric monitors disk utilization"
  alarm_actions       = var.aws_sns_topic_arn != "" ? [var.aws_sns_topic_arn] : []

  dimensions = {
    InstanceId = var.instance_id
    device     = "xvda1"
    fstype     = "xfs"
    path       = "/"
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
  alarm_actions       = var.aws_sns_topic_arn != "" ? [var.aws_sns_topic_arn] : []

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
  log_group_name = "/${var.log_group_prefix}/${var.log_group_failed_ssh}"
  pattern        = "[Mon, day, timestamp, ip, id, msg1= Failed, msg2= password, ...]"

  metric_transformation {
    name      = "FailedSSHAttempts"
    namespace = "CustomMetrics/${var.instance_name}"
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "failed_ssh_alarm" {
  alarm_name          = "${var.instance_name}-failed-ssh-attempts"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "FailedSSHAttempts"
  namespace           = "CustomMetrics/${var.instance_name}"
  period              = var.alarm_period
  statistic           = "Sum"
  threshold           = var.failed_ssh_threshold
  alarm_description   = "Alert on excessive failed SSH attempts"
  treat_missing_data  = "notBreaching"
  alarm_actions       = var.aws_sns_topic_arn != "" ? [var.aws_sns_topic_arn] : []

  tags = {
    Name        = "${var.instance_name}-ssh-alarm"
    Instance    = var.instance_name
    MonitorType = "Security"
  }
}
