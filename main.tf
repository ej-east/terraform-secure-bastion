locals {
  common_tags = {
    Project = "my-ec2-project"
    Environment = var.environment
    Owner = "ej"
    ManagedBy = "ej"
    CreateDate = formatdate("YYYY-MM-DD", timestamp())
  }

  name_prefix = "${var.project_name}-${var.environment}"

}

module "keypair" {
  source = "./modules/key-pair"
  
  create_key = true
  name_prefix = local.name_prefix
  
  tags = local.common_tags
}