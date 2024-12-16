output "instance_id" {
  description = "The ID of the EC2 instance"
  value       = aws_instance.this.id
}

output "instance_ids" {
  value = [aws_instance.this.id] # Wrap the instance ID in a list
}