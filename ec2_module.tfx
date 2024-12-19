#EC2 Public
module "ec2_bastion" {
  source             = "./modules/aws-ec2"
  instance_name      = format("%s-%s-%s-bastion", var.customer, var.project, var.environment)
  environment_name   = "sandbox"
  instance_type      = "t3.micro"
  ami                = "ami-05d38da78ce859165"
  key_name           = "sandbox-key"
  volume_size        = 10
  subnet_id          = module.vpc.public_subnets[0]
  security_group_ids = [aws_security_group.bastion-sg.id]
  ssm_role           = aws_iam_instance_profile.ssm-profile.name
  allocate_eip       = true
  associate_public_ip_address = true
  tags               = merge(local.common_tags, { OS = "ubuntu", Backup = "DailyBackup" })
}

#EC2 Private
module "ec2_app1" {
  source             = "./modules/aws-ec2"
  instance_name      = format("%s-%s-%s-app1", var.customer, var.project, var.environment)
  environment_name   = "staging"
  instance_type      = "t3.micro"
  ami                = "ami-05d38da78ce859165"
  key_name           = "sandbox-key"
  volume_size        = 40
  subnet_id          = module.vpc.private_subnets[0]
  security_group_ids = [aws_security_group.app1.id]
  ssm_role           = aws_iam_instance_profile.ssm-profile.name
  tags               = merge(local.common_tags, { OS = "ubuntu", Backup = "DailyBackup" })
}

module "ec2_centos" {
  source             = "./modules/aws-ec2"
  instance_name      = format("%s-%s-%s-centos", var.customer, var.project, var.environment)
  environment_name   = "staging"
  instance_type      = "t3.micro"
  ami                = "ami-055e3d4f0bbeb5878"
  key_name           = "sandbox-key"
  volume_size        = 40
  subnet_id          = module.vpc.private_subnets[0]
  security_group_ids = [aws_security_group.app1.id]
  ssm_role           = aws_iam_instance_profile.ssm-profile.name
  tags               = merge(local.common_tags, { OS = "centos", Backup = "DailyBackup" })
}