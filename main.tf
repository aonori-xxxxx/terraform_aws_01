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
    key     = "opro-dev.tfstate"
    region  = "ap-northeast-1"
    profile = "terraform"
  }
}

# - - - - - - - - - - - - - -
#provider
# - - - - - - - - - - - - - -
provider "aws" {
  # profile = "terraform"
  region  = var.region
}

# - - - - - - - - - - - - - -
#variables
# - - - - - - - - - - - - - -

variable "project" {
  type = string

}
variable "environment" {
  type = string
}
#region
variable "region" {
  type = string
}

#VPC
variable "vpc_cidr" {
  type = string
}

#subnet
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