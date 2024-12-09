variable "instance_name" {
  description = "Base name for the instance (unique per instance)"
  type        = string
}

variable "associate_public_ip_address" {
  description = "public ip"
  type        = bool
  default = false
}

variable "environment_name" {
  description = "environment name"
  type        = string
}

variable "ssm_role" {
  description = "instance profile"
  type        = string
}

variable "instance_type" {
  description = "Type of EC2 instance"
  type        = string
}

variable "ami" {
  description = "AMI ID for the instance"
  type        = string
}

variable "key_name" {
  description = "Key name for the EC2 instance"
  type        = string
}

variable "volume_size" {
  description = "Root volume size (GB)"
  type        = number
}

variable "subnet_id" {
  description = "Subnet ID for the instance"
  type        = string
}

variable "security_group_ids" {
  description = "List of security group IDs"
  type        = list(string)
}

variable "tags" {
  description = "Tags for the instance"
  type        = map(string)
  default     = {}
}

locals {
  common_tags = {
    Project     = var.project
    Environment = var.environment
    Terraform   = "Yes"
  }
}

  variable "project" {
  default = "sgi"
}

variable "environment" {
  default = "staging"
}

variable "customer_name" {
  default = "sgi"
}

variable "allocate_eip" {
  description = "Flag to allocate an Elastic IP for the instance"
  type        = bool
  default     = false
}