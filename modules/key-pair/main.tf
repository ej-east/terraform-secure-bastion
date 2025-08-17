resource "tls_private_key" "rsa_private_key" {
  count     = var.create_key ? 1 : 0
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "private_key" {
  count                = var.create_key ? 1 : 0
  filename             = pathexpand("~/.ssh/${var.keyname}.pem")
  file_permission      = "600"
  directory_permission = "700"
  content              = tls_private_key.rsa_private_key[0].private_key_openssh
}

resource "aws_key_pair" "ec2_secure_key" {
  key_name_prefix = var.name_prefix
  public_key      = var.create_key ? tls_private_key.rsa_private_key[0].public_key_openssh : file(var.existing_key_path)

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-keypair"
  })
}