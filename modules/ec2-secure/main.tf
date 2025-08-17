resource "aws_security_group" "bastion_host" {
  name_prefix = "${var.name_prefix}-bastion-host"
  vpc_id      = data.aws_subnet.selected.vpc_id

  dynamic "ingress" {
    for_each = var.allowed_ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = var.allowed_cidr_blocks
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
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


  tags = merge(var.tags, {
    Name = "${var.name_prefix}-bastion-host"
  })
}