# - - - - - - - - - - - - - -
#Terraform configuration
# - - - - - - - - - - - - - -
terraform {
  required_version = ">=1.9.5"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>3.0"
    }
  }
  backend "s3" {
    bucket  = "terraform-dev-202409"
    key     = "dev.tfstate"
    region  = "ap-northeast-1"
    profile = "terraform"
  }
}

# - - - - - - - - - - - - - -
#Provider
# - - - - - - - - - - - - - -
provider "aws" {
  profile = "terraform"
  region  = var.region
}

# - - - - - - - - - - - - - -
#Variables
# - - - - - - - - - - - - - -

variable "project" {
  type = string

}
variable "environment" {
  type = string
}
#Region
variable "region" {
  type = string
}

#VPC
variable "vpc_cidr" {
  type = string
}

#Subnet
variable "public_1a" {
  type = string
}
variable "public_1c" {
  type = string
}
variable "public_1d" {
  type = string
}
variable "private_sv_1a" {
  type = string
}
variable "private_sv_1c" {
  type = string
}
variable "private_sv_1d" {
  type = string
}
variable "private_db_1a" {
  type = string
}
variable "private_db_1c" {
  type = string
}
variable "private_db_1d" {
  type = string
}
