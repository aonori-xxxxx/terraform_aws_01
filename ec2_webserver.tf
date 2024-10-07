# - - - - - - - - - - - - - -
# key pair
# - - - - - - - - - - - - - -
resource "aws_key_pair" "keypair" {
  key_name   = "${var.project}-keypair"
  public_key = file("./src/${var.project}-keypair.pub")
  tags = {
    Name    = "${var.project}-keypair"
    Project = var.project
    Env     = var.environment
  }
}

# - - - - - - - - - - - - - -
# EC2 Instance
# - - - - - - - - - - - - - -
resource "aws_instance" "web_server2" {
  ami                         = data.aws_ami.web.id
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.private_sv_1a.id
  associate_public_ip_address = false
  iam_instance_profile        = aws_iam_instance_profile.ec2_profile.name
  vpc_security_group_ids = [
    aws_security_group.web_sg.id,
    aws_security_group.mgmt_sg.id
  ]
  key_name = aws_key_pair.keypair.key_name
  tags = {
    Name    = "${var.project}-web"
    Project = var.project
    Env     = var.environment
    Type    = "web"
  }

  user_data = <<-EOF
  #!/bin/bash
  dnf install -y httpd
  systemctl start httpd
  echo OK > /var/www/html/index.html
  chmod 664 /var/www/html/index.html
  EOF

}


