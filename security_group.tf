# - - - - - - - - - - - - - -
#Security Group
# - - - - - - - - - - - - - -

#Web Security Group

resource "aws_security_group" "web_sg" {
  name        = "${var.project}-web-sg"
  description = "web front role security group"
  vpc_id      = aws_vpc.vpc.id
  tags = {
    Name    = "${var.project}-web-sg"
    Project = var.project
    Env     = var.environment
  }
}

resource "aws_security_group_rule" "web_in_http" {
  security_group_id = aws_security_group.web_sg.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 80
  to_port           = 80
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "web_in_https" {
  security_group_id = aws_security_group.web_sg.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 443
  to_port           = 443
  cidr_blocks       = ["0.0.0.0/0"]
}


resource "aws_security_group_rule" "out" {
  security_group_id = aws_security_group.web_sg.id
  type              = "egress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
}


# mgmt security group
resource "aws_security_group" "mgmt_sg" {
  name        = "${var.project}-mgmt-sg"
  description = "management role security group"
  vpc_id      = aws_vpc.vpc.id

  tags = {
    Name    = "${var.project}-mgmt-sg"
    Project = var.project
    Env     = var.environment
  }
}

resource "aws_security_group_rule" "mgmt_in_ssh" {
  security_group_id = aws_security_group.mgmt_sg.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 22
  to_port           = 22
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "mgmt_out" {
  security_group_id = aws_security_group.mgmt_sg.id
  type              = "egress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
}

# db security group
resource "aws_security_group" "db_sg" {
  name        = "${var.project}-db-sg"
  description = "database role security group"
  vpc_id      = aws_vpc.vpc.id
  tags = {
    Name    = "${var.project}-db-sg"
    Project = var.project
    Env     = var.environment
  }
}

resource "aws_security_group_rule" "db_in_tcp3306" {
  security_group_id = aws_security_group.db_sg.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 3306
  to_port           = 3306
  cidr_blocks       = ["${var.vpc_cidr}"]
}

resource "aws_security_group_rule" "db_out" {
  security_group_id = aws_security_group.db_sg.id
  type              = "egress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
}

