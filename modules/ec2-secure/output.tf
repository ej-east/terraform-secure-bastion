output "public_ip" {
  description = "The public IP of the ec2 instance"
  value = aws_instance.bastion_host.public_ip
}

output "aws_instance_id" {
  description = "The ID of the ec2 instance"
  value = aws_instance.bastion_host.id
}

output "aws_instance_arn" {
  description = "The ARN of the ec2 instance"
  value = aws_instance.bastion_host.arn
}