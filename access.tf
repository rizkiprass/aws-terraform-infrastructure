provider "aws" {
  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}

terraform {
  backend "s3" {
    bucket = "sandbox-statefile-9-12"
    key    = "sandbox"
    region = "us-west-2"
  }
}