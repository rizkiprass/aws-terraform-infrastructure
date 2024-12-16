#resource "aws_security_group" "ec2-rds" {
#  name        = format("%s-%s-ec2-rds-sg", var.project, var.environment)
#  description = "Application Security Group"
#  vpc_id      = module.vpc.vpc_id
#
#  #Allow outgoing traffic to specific
#  #  egress {
#  #    from_port   = 15432
#  #    to_port     = 15432
#  #    protocol    = "tcp"
#  #    security_groups = [aws_security_group.rds-ec2-sg.id]
#  #    description = "ssh"
#  #  }
#}

resource "aws_security_group" "app1" {
  name        = format("%s-%s-%s-app1-sg", var.customer, var.project, var.environment)
  description = "App1 Security Group"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb-sg.id]
    description     = "allow http connection from alb"
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.cidr]
    description = "allow http connection from internal vpc"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "allow all traffic"
  }

  tags = merge(local.common_tags, {
    Name = format("%s-%s-app1-sg", var.customer, var.environment),
  })

#  lifecycle {
#    ignore_changes = [
#    ingress, egress]
#  }
}