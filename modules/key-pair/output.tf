output "key_name" {
  description = "Output of the AWS Key Pair Name"
  value       = aws_key_pair.ec2_secure_key.key_name
}

output "private_key_path" {
  description = "Path to private key file (only when creating a new key)"
  value       = var.create_key ? local_file.private_key[0].filename : null
}

output "keypair_arn" {
  description = "ARN of  the key pair"
  value       = aws_key_pair.ec2_secure_key.arn
}