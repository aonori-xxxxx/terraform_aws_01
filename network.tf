# - - - - - - - - - - - - - -
#VPC
# - - - - - - - - - - - - - -
resource "aws_vpc" "vpc" {
  cidr_block                       = var.vpc_cidr
  instance_tenancy                 = "default"
  enable_dns_support               = true
  enable_dns_hostnames             = true
  assign_generated_ipv6_cidr_block = false

  tags = {
    Name    = "${var.project}-${var.environment}-vpc"
    Project = var.project
    Env     = var.environment
  }
}

# - - - - - - - - - - - - - -
#Subnet
# - - - - - - - - - - - - - -

resource "aws_subnet" "public_1a" {
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = "ap-northeast-1a"
  cidr_block              = var.public_1a
  map_public_ip_on_launch = true
  tags = {
    Name    = "${var.project}-public_1a"
    Project = var.project
    Env     = var.environment
    Type    = "public"
  }
}

resource "aws_subnet" "public_1c" {
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = "ap-northeast-1c"
  cidr_block              = var.public_1c
  map_public_ip_on_launch = true
  tags = {
    Name    = "${var.project}-public_1c"
    Project = var.project
    Env     = var.environment
    Type    = "public"
  }
}

resource "aws_subnet" "public_1d" {
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = "ap-northeast-1d"
  cidr_block              = var.public_1d
  map_public_ip_on_launch = true
  tags = {
    Name    = "${var.project}-public_1d"
    Project = var.project
    Env     = var.environment
    Type    = "public"
  }
}



resource "aws_subnet" "private_sv_1a" {
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = "ap-northeast-1a"
  cidr_block              = var.private_sv_1a
  map_public_ip_on_launch = true
  tags = {
    Name    = "${var.project}-private_sv_1a"
    Project = var.project
    Env     = var.environment
    Type    = "private"
  }
}

resource "aws_subnet" "private_sv_1c" {
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = "ap-northeast-1c"
  cidr_block              = var.private_sv_1c
  map_public_ip_on_launch = true
  tags = {
    Name    = "${var.project}-private_sv_1c"
    Project = var.project
    Env     = var.environment
    Type    = "private"
  }
}

resource "aws_subnet" "private_sv_1d" {
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = "ap-northeast-1d"
  cidr_block              = var.private_sv_1d
  map_public_ip_on_launch = true
  tags = {
    Name    = "${var.project}-private_sv_1d"
    Project = var.project
    Env     = var.environment
    Type    = "private"
  }
}

resource "aws_subnet" "private_db_1a" {
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = "ap-northeast-1a"
  cidr_block              = var.private_db_1a
  map_public_ip_on_launch = true
  tags = {
    Name    = "${var.project}-private_db_1a"
    Project = var.project
    Env     = var.environment
    Type    = "private"
  }
}

resource "aws_subnet" "private_db_1c" {
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = "ap-northeast-1c"
  cidr_block              = var.private_db_1c
  map_public_ip_on_launch = true
  tags = {
    Name    = "${var.project}-private_db_1c"
    Project = var.project
    Env     = var.environment
    Type    = "private"
  }
}

resource "aws_subnet" "private_db_1d" {
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = "ap-northeast-1d"
  cidr_block              = var.private_db_1d
  map_public_ip_on_launch = true
  tags = {
    Name    = "${var.project}-private_db_1d"
    Project = var.project
    Env     = var.environment
    Type    = "private"
  }
}


# - - - - - - - - - - - - - -
#Route table
# - - - - - - - - - - - - - -

#Public


resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name    = "${var.project}-public-rt"
    Project = var.project
    Env     = var.environment
    Type    = "public"
  }
}


#Private

resource "aws_route_table" "private_rt_1a" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw_1a.id
  }
  tags = {
    Name    = "${var.project}-private-rt-1a"
    Project = var.project
    Env     = var.environment
    Type    = "private"
  }
}

# resource "aws_route_table" "private_rt_1c" {
#   vpc_id = aws_vpc.vpc.id
#   route {
#     cidr_block = "0.0.0.0/0"
#     nat_gateway_id = aws_nat_gateway.nat_gw_1c.id
#   }
#   tags = {
#     Name    = "${var.project}-private-rt-1c"
#     Project = var.project
#     Env     = var.environment
#     Type    = "private"
#   }
# }

# resource "aws_route_table" "private_rt_1d" {
#   vpc_id = aws_vpc.vpc.id
#   route {
#     cidr_block = "0.0.0.0/0"
#     nat_gateway_id = aws_nat_gateway.nat_gw_1d.id
#   }
#   tags = {
#     Name    = "${var.project}-private-rt-1d"
#     Project = var.project
#     Env     = var.environment
#     Type    = "private"
#   }
# }

# - - - - - - - - - - - - - -
#Route table association
# - - - - - - - - - - - - - -


resource "aws_route_table_association" "public_rt" {
  for_each = {
    subnet1 = aws_subnet.public_1a.id
    subnet2 = aws_subnet.public_1c.id
    subnet3 = aws_subnet.public_1d.id
  }
  subnet_id      = each.value
  route_table_id = aws_route_table.public_rt.id
}


#Private
resource "aws_route_table_association" "private_rt_1a" {
  route_table_id = aws_route_table.private_rt_1a.id
  subnet_id      = aws_subnet.private_sv_1a.id
}


# resource "aws_route_table_association" "private_rt_1c" {
#   route_table_id = aws_route_table.private_rt_1c.id
#   subnet_id      = aws_subnet.private_sv_1c.id

# }

# resource "aws_route_table_association" "private_rt_1d" {
#   route_table_id = aws_route_table.private_rt_1d.id
#   subnet_id      = aws_subnet.private_sv_1d.id
# }

# - - - - - - - - - - - - - -
#Nat Gateway
# - - - - - - - - - - - - - -
# Elastic IPの作成（NAT Gateway用）
resource "aws_eip" "eip_nat_gw_1a" {
  vpc = true
  tags = {
    Name    = "${var.project}-eip-1a"
    Project = var.project
    Env     = var.environment
  }
}
# resource "aws_eip" "eip_nat_gw_1c" {
#   vpc = true
#   tags = {
#     Name    = "${var.project}-eip-1c"
#     Project = var.project
#     Env     = var.environment
#   }
# }
# resource "aws_eip" "eip_nat_gw_1d" {
#   vpc = true
#   tags = {
#     Name    = "${var.project}-eip-1d"
#     Project = var.project
#     Env     = var.environment
#   }
# }
# NAT Gatewayの作成
resource "aws_nat_gateway" "nat_gw_1a" {
  allocation_id = aws_eip.eip_nat_gw_1a.id
  subnet_id     = aws_subnet.public_1a.id
  tags = {
    Name    = "${var.project}-nat-gw-1a"
    Project = var.project
    Env     = var.environment
    Type    = "private"
  }
}

# resource "aws_nat_gateway" "nat_gw_1c" {
#   allocation_id = aws_eip.eip_nat_gw_1c.id
#   subnet_id     = aws_subnet.public_1c.id
#   tags = {
#     Name    = "${var.project}-nat-gw-1c"
#     Project = var.project
#     Env     = var.environment
#     Type    = "private"
#   }
# }

# resource "aws_nat_gateway" "nat_gw_1d" {
#   allocation_id = aws_eip.eip_nat_gw_1d.id
#   subnet_id     = aws_subnet.public_1d.id
#   tags = {
#     Name    = "${var.project}-nat-gw-1d"
#     Project = var.project
#     Env     = var.environment
#     Type    = "private"
#   }
# }

# - - - - - - - - - - - - - -
#Internet Gateway
# - - - - - - - - - - - - - -
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name    = "${var.project}-igw"
    Project = var.project
    Env     = var.environment
  }
}
resource "aws_route" "public_rt_ig" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}