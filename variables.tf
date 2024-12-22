variable "access_key" {
  default = ""
}

variable "secret_key" {
  default = ""
}

variable "Backup" {
  default = "BackupDaily"
}

variable "region" {
  default = "ap-southeast-3"
}

variable "cidr" {
  default = "10.10.0.0/16"
}

variable "Public_Subnet_AZA" {
  default = "10.10.1.0/24"
}

variable "Public_Subnet_AZB" {
  default = "10.10.2.0/24"
}

variable "Private_Subnet_AZA" {
  default = "10.10.3.0/24"
}

variable "Private_Subnet_AZB" {
  default = "10.10.4.0/24"
}

variable "Data_Subnet_AZA" {
  default = "10.10.5.0/24"
}

variable "Data_Subnet_AZB" {
  default = "10.10.6.0/24"
}

#Tagging Common
variable "environment" {
  default = "staging"
}

variable "project" {
  default = "sandbox"
}

variable "customer" {
  default = "customer"
}

locals {
  common_tags = {
    Project     = var.project
    Environment = var.environment
    Terraform   = "Yes"
  }
}

// Misc Tag
variable "Birthday" {
  default = "07-06-2024"
}