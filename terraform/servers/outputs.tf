output "vault_ip" {
  value = aws_instance.vault.public_ip
}

output "analytics_ip" {
  value = aws_instance.analytics.public_ip
}

output "client_ip" {
  value = aws_instance.client.public_ip
}