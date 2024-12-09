locals {
  ec2_name = format("%s-%s-%s", var.customer_name, var.environment_name, var.instance_name)
}

resource "aws_instance" "this" {
  ami                         = var.ami
  instance_type               = var.instance_type
  associate_public_ip_address = var.associate_public_ip_address
  key_name                    = var.key_name
  subnet_id                   = var.subnet_id
  iam_instance_profile        = var.ssm_role
  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }
  vpc_security_group_ids = var.security_group_ids

  root_block_device {
    volume_size           = var.volume_size
    volume_type           = "gp3"
    iops                  = 3000
    encrypted             = true
    delete_on_termination = true
    tags = merge(var.tags, {
      Name = format("%s-ebs", local.ec2_name)
    })
  }

  tags = merge(var.tags, { Name = local.ec2_name })
}

# Elastic IP Allocation
resource "aws_eip" "this" {
  count    = var.allocate_eip ? 1 : 0
  instance = aws_instance.this.id
  tags = merge(var.tags, {
    Name = format("%s-%s-eip", var.environment_name, var.instance_name)
  })
}