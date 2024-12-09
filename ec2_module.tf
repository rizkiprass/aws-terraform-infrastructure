#EC2 Public
module "ec2_jump" {
  source             = "./modules/aws-ec2"
  instance_name      = "Bastion"
  environment_name   = "staging"
  instance_type      = "t3.small"
  ami                = "ami-081205ca71b3f3635"
  key_name           = "sgi-indramayu-jump-key"
  volume_size        = 40
  subnet_id          = module.vpc.public_subnets[0]
  security_group_ids = [aws_security_group.ec2-bastion.id]
  ssm_role           = aws_iam_instance_profile.ssm-profile.name
  allocate_eip       = true
  tags               = merge(local.common_tags, { OS = "ubuntu", Backup = "DailyBackup" })
}

#EC2 Private
module "ec2_app1" {
  source             = "./modules/aws-ec2"
  instance_name      = "app"
  environment_name   = "staging"
  instance_type      = "t3.medium"
  ami                = "ami-081205ca71b3f3635"
  key_name           = "sgi-indramayu-app1-key"
  volume_size        = 40
  subnet_id          = module.vpc.private_subnets[0]
  security_group_ids = [aws_security_group.app1.id]
  ssm_role           = aws_iam_instance_profile.ssm-profile.name
  tags               = merge(local.common_tags, { OS = "ubuntu", Backup = "DailyBackup" })
}

