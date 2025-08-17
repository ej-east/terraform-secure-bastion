locals {
  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    Owner       = "ej"
    ManagedBy   = "ej"
    CreateDate  = formatdate("YYYY-MM-DD", timestamp())
  }

  name_prefix = "${var.project_name}-${var.environment}"

}

module "keypair" {
  source = "./modules/key-pair"

  create_key  = true
  name_prefix = local.name_prefix

  tags = local.common_tags
}

module "bastion" {
  source = "./modules/ec2-secure"

  user_data_file      = "./user_data/boot.sh"
  subnet_id           = data.aws_subnets.public.ids[0]
  allowed_cidr_blocks = var.allowed_cidr_blocks
  name_prefix         = local.name_prefix
  key_name            = module.keypair.key_name

  tags = local.common_tags
}
