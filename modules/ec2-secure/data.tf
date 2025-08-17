data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

data "aws_subnet" "selected" {
  id = var.subnet_id
}

data "aws_vpc" "selected" {
  id = data.aws_subnet.selected.vpc_id
}

data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["dlm.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}
