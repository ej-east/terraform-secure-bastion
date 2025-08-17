resource "aws_iam_policy" "cloudwatch_agent_policy" {
  name_prefix = var.name_prefix


  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "cloudwatch:PutMetricData",
          "ec2:DescribeVolumes",
          "ec2:DescribeTags",
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogStreams",
          "logs:PutRetentionPolicy",
          "ssm:GetParameter"
        ],
        "Resource" : "*"
      }
    ]
  })
  tags = var.tags
}


resource "aws_iam_role" "cloudwatch_agent_role" {
  name_prefix = var.name_prefix
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : "sts:AssumeRole",
        "Principal" : {
          "Service" : "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = var.tags
}
resource "aws_iam_role_policy_attachment" "cloudwatch_agent_policy_attachment" {
  role       = aws_iam_role.cloudwatch_agent_role.name
  policy_arn = aws_iam_policy.cloudwatch_agent_policy.arn
}

resource "aws_iam_instance_profile" "cloudwatch_instance_profile" {
  name_prefix = var.name_prefix
  role        = aws_iam_role.cloudwatch_agent_role.name
}
