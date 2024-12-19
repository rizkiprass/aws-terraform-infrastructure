variable "bastion-port-list" {
  type = map(any)
  default = {
    "ssh" = 22
  }
}

resource "aws_security_group" "bastion-sg" {
  name        = format("%s-%s-%s-sg", var.customer, var.project, var.environment)
  description = "Bastion Security Group"
  vpc_id      = module.vpc.vpc_id
  dynamic "ingress" {
    for_each = var.bastion-port-list
    content {
      from_port = ingress.value
      to_port   = ingress.value
      protocol  = "tcp"
      cidr_blocks = [
      "0.0.0.0/0"]
      description = ingress.key
    }
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = [
    "0.0.0.0/0"]
  }
  tags = merge(local.common_tags, {
    Name = format("%s-%s-%s-sg", var.customer, var.project, var.environment)
  })

  lifecycle {
    ignore_changes = [
    ingress]
  }
}