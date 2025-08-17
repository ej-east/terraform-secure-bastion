output "bastion_public_ip" {
  description = "Public IP address of the bastion host"
  value       = module.aws_instance.public_ip
}

output "bastion_instance_id" {
  description = "Instance ID of the bastion host"
  value       = module.aws_instance.aws_instance_id
}

output "ssh_connection_command" {
  description = "SSH connection command for the bastion host"
  value       = "ssh -i ${module.keypair.private_key_path} ec2-user@${module.aws_instance.public_ip}"
}