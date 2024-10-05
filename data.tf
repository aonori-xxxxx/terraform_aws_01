data "aws_prefix_list" "s3_p1" {
  name = "com.amazonaws.*.s3"
}

data "aws_ami" "web" {
  most_recent = true
  owners      = ["self", "amazon"]
  filter {
    name   = "name"
    values = ["al2023-ami-*-kernel-6.1-x86_64"]
    # values = ["amzn2-ami-kernel-5.10-hvm-2.0.*.0-x86_64-gp2"]
  }
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}
