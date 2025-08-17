output "bastion_host_public_ip" {
  description = "The public IP of the bastion_host"
  value       = aws_instance.bastion_host.public_ip
}

output "bastion_instance_id" {
  description = "The ID of the bastion_host"
  value       = aws_instance.bastion_host.id
}

output "bastion_host_arn" {
  description = "The ARN of the bastion_host"
  value       = aws_instance.bastion_host.arn
}

output "bastion_host_security_group_id" {
  description = "The security group ID of the bastion_host"
  value       = aws_security_group.bastion_host.id
}
