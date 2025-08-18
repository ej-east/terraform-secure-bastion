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

module "cloudwatch_bastion" {
  source = "./modules/cloudwatch"

  instance_name = "bastion_host"
  instance_id   = module.bastion.bastion_instance_id

  tags = local.common_tags
}

resource "aws_kms_key" "aws_sns_topic" {
  description             = "KMS key for SNS topic encryption"
  deletion_window_in_days = 10
  enable_key_rotation     = true
}

resource "aws_sns_topic" "bastion_sns" {
  name              = "${local.name_prefix}-sns"
  kms_master_key_id = aws_kms_key.aws_sns_topic.arn
}

resource "aws_sns_topic_subscription" "bastion_email_subscriber_one" {
  topic_arn = aws_sns_topic.bastion_sns.arn
  protocol  = "email"
  endpoint  = var.bastion_email_subscriber_one
}
