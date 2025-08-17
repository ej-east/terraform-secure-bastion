output "bastion_public_ip" {
  description = "Public IP address of the bastion host"
  value       = module.bastion.bastion_host_public_ip
}

output "bastion_instance_id" {
  description = "Instance ID of the bastion host"
  value       = module.bastion.bastion_instance_id
}

output "ssh_connection_command" {
  description = "SSH connection command for the bastion host"
  value       = "ssh -i ${module.keypair.private_key_path} ec2-user@${module.bastion.bastion_host_public_ip}"
}
