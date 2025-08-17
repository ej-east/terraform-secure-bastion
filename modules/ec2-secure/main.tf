resource "aws_security_group" "bastion_host" {
  name_prefix = "${var.name_prefix}-bastion-host"
  description = "This security group allows only ssh traffic from one IP address and allows traffic to go anywhere"
  vpc_id      = data.aws_subnet.selected.vpc_id

  dynamic "ingress" {
    for_each = var.allowed_ports
    content {
      description = "Only allows SSH traffic from a specified IP"
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = var.allowed_cidr_blocks
    }
  }

  egress {
    description = "HTTP for package updates"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    #tfsec:ignore:aws-ec2-no-public-egress-sgr
    cidr_blocks = ["0.0.0.0/0"] # Required for updates
  }

  egress {
    description = "HTTPS for package updates"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    #tfsec:ignore:aws-ec2-no-public-egress-sgr
    cidr_blocks = ["0.0.0.0/0"] # Required for updates

  }

  egress {
    description = "SSH to private subents"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [data.aws_vpc.selected.cidr_block]
  }

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-jumpbox-sg"
  })
}

resource "aws_instance" "bastion_host" {
  ami                         = coalesce(var.ami_id, data.aws_ami.amazon_linux_2.id)
  instance_type               = var.instance_type
  key_name                    = var.key_name
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [aws_security_group.bastion_host.id]
  associate_public_ip_address = true
  user_data                   = file(var.user_data_file)
  iam_instance_profile        = aws_iam_instance_profile.cloudwatch_instance_profile.name

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  root_block_device {
    encrypted   = var.encrypt
    volume_type = "gp3"
  }

  lifecycle {
    prevent_destroy = false
    ignore_changes  = [ami]
  }

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-bastion-host"
  })
}
