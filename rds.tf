# - - - - - - - - - - - - - -
#RDS パラメータグループ
# - - - - - - - - - - - - - -


resource "aws_db_parameter_group" "mysql_standalone_parametergroup" {
  name   = "${var.project}-parametergroup"
  family = "aurora-mysql8.0"

  parameter {
    name  = "aurora_parallel_query"
    value = "0"
  }

  parameter {
    name  = "general_log"
    value = "1"
  }

  parameter {
    name  = "interactive_timeout"
    value = "86400"
  }

  parameter {
    name  = "log_bin_trust_function_creators"
    value = "1"
  }

  parameter {
    name  = "max_allowed_packet"
    value = "33554432"
  }

  parameter {
    name  = "transaction_isolation"
    value = "READ-COMMITTED"

  }

  parameter {
    name  = "wait_timeout"
    value = "86400"

  }

}

# - - - - - - - - - - - - - -
#RDS オプショングループ
# - - - - - - - - - - - - - -

resource "aws_db_option_group" "mysql_optiongroup" {
  name                 = "${var.project}-optiongroup"
  engine_name          = "aurora"
  major_engine_version = "8.0"
  option {
    option_name = "Timezone"

    option_settings {
      name  = "TIME_ZONE"
      value = "JST"
    }
  }
}

resource "aws_db_option_group" "mysql_optiongroup" {
  name                 = "${var.project}-optiongroup"
  engine_name          = "aurora-mysql"
  major_engine_version = "8.0"
}

# - - - - - - - - - - - - - -
#RDS サブネットグループ
# - - - - - - - - - - - - - -

resource "aws_db_subnet_group" "mysql_standalone_subnetgroup" {
  name = "${var.project}-rds-subnetgroup"
  subnet_ids = [
    aws_subnet.private_db_1a.id,
    aws_subnet.private_db_1c.id,
    aws_subnet.private_db_1d.id,

  ]
  tags = {
    Name    = "${var.project}-rds-subnetgroup"
    Project = var.project
    Env     = var.environment
  }
}


# - - - - - - - - - - - - - -
#RDS Instance
# - - - - - - - - - - - - - -


# DBパスワードを作成
# これ用のterraform initが必要。要注意
resource "random_string" "rds_password" {
  length  = 16
  special = false
}

# Auroraの作成
#-----------------

# Aurora クラスターの作成
resource "aws_rds_cluster" "aurora_cluster" {
  cluster_identifier          = "${var.project}-aurora"
  engine                      = "aurora-mysql"
  engine_version              = "8.0.mysql_aurora.3.05.2"
  master_username             = "admin"
  master_password             = random_string.rds_password.result
  backup_retention_period     = 5
  preferred_backup_window     = "07:00-09:00"
  allow_major_version_upgrade = false
  db_subnet_group_name        = aws_db_subnet_group.mysql_standalone_subnetgroup.name
  vpc_security_group_ids      = [aws_security_group.db_sg.id]

  #   #削除可能
  deletion_protection = false
  skip_final_snapshot = true
  apply_immediately   = true

  #削除不可
  # deletion_protection =  true
  # skip_final_snapshot = false
  # apply_immediately   = false

}

# Aurora インスタンスの作成
resource "aws_rds_cluster_instance" "aurora_instance" {
  identifier           = "aurora-instance-demo"
  cluster_identifier   = aws_rds_cluster.aurora_cluster.id
  instance_class       = "db.t3.medium"
  engine               = "aurora-mysql"
  publicly_accessible  = false
  db_subnet_group_name = aws_db_subnet_group.mysql_standalone_subnetgroup.name
}





#RDSの作成
#-----------------

# resource "aws_db_instance" "mysql" {
#   instance_class         = "db.t3.medium"
# }
# resource "aws_db_instance" "mysql_standalone" {
#   engine                 = "aurora"
#   engine_version         = "8.0.mysql_aurora.3.05.2"
#   identifier             = "${var.project}-aurora"
#   username               = "admin"
#   password               = random_string.rds_password.result
#   instance_class         = "db.t3.micro"
#   allocated_storage      = 20
#   max_allocated_storage  = 50
#   storage_type           = "gp2"
#   storage_encrypted      = false
#   multi_az               = false
#   availability_zone      = "ap-northeast-1a"
#   db_subnet_group_name   = aws_db_subnet_group.mysql_standalone_subnetgroup.name
#   vpc_security_group_ids = [aws_security_group.db_sg.id]
#   publicly_accessible    = false
#   port                   = 3306

#   name                 = "${var.project}-aurora"
#   parameter_group_name = aws_db_parameter_group.mysql_standalone_parametergroup.name
#   option_group_name    = aws_db_option_group.mysql_optiongroup.name

#   backup_window              = "04:00-05:00"
#   backup_retention_period    = 0
#   maintenance_window         = "Mon:05:00-Mon:08:00"
#   auto_minor_version_upgrade = false

#   #   #通常
#   #   # deletion_protection = true
#   #   # skip_final_snapshot = false
#   #   # apply_immediately   = false

#   #削除
#   deletion_protection = false
#   skip_final_snapshot = true
#   apply_immediately   = true

#   tags = {
#     Name    = "${var.project}-aurora"
#     Project = var.project
#     Env     = var.environment
#   }
# }
