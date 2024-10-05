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
# SSM Parameter Store
# - - - - - - - - - - - - - -

# resource "aws_ssm_parameter" "host" {
#   name  = "/${var.project}/${var.environment}/app/MYSQL_HOST"
#   type  = "String"
#   value = aws_db_instance.mysql_standalone.address

# }

# resource "aws_ssm_parameter" "port" {
#   name  = "/${var.project}/${var.environment}/app/MYSQL_PORT"
#   type  = "String"
#   value = aws_db_instance.mysql_standalone.port

# }

# resource "aws_ssm_parameter" "database" {
#   name  = "/${var.project}/${var.environment}/app/MYSQL_DATABASE"
#   type  = "String"
#   value = aws_db_instance.mysql_standalone.name
# }

# resource "aws_ssm_parameter" "user" {
#   name  = "/${var.project}/${var.environment}/app/MYSQL_USERNAME"
#   type  = "SecureString"
#   value = aws_db_instance.mysql_standalone.username
# }

# resource "aws_ssm_parameter" "password" {
#   name  = "/${var.project}/${var.environment}/app/MYSQL_PASSWORD"
#   type  = "SecureString"
#   value = aws_db_instance.mysql_standalone.password

# }
# - - - - - - - - - - - - - -
# EC2 Instance
# - - - - - - - - - - - - - -
resource "aws_instance" "web_server2" {
  ami                         = "ami-0bb890eb2677ad3dd"
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
  yum install -y amazon-ssm-agent
  systemctl start amazon-ssm-agent
  echo  "test" > /home/ec2-user/taaa.txt
  EOF

}


