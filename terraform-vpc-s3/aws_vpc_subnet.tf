# VPC create
resource "aws_vpc" "project_h_vpc" {
  cidr_block  = "10.0.0.0/16"

  tags = {
    Name = "project_h_rs"
  }
}

# Subnet create
resource "aws_subnet" "public_subnet_1" {
  vpc_id     = aws_vpc.project_h_vpc.id
  cidr_block = "10.0.1.0/24"

  availability_zone = "ap-northeast-2a"

  tags = {
    Name = "project-h-public-subnet-1"
  }
}

resource "aws_subnet" "public_subnet_2" {
  vpc_id     = aws_vpc.project_h_vpc.id
  cidr_block = "10.0.2.0/24"

  availability_zone = "ap-northeast-2b"

  tags = {
    Name = "project-h-public-subnet-2"
  }
}

# Internet gateway create
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.project_h_vpc.id

  tags = {
    Name = "project-h-igw"
  }
}

# Route_table, association create
resource "aws_route_table" "project_h_rt" {
  vpc_id = aws_vpc.project_h_vpc.id

  #Ingress Type Inner rule
  #route {
  #  cidr_bloc = "0.0.0.0/0"
  #  gateway_id = aws_internet_gateway.igw.id
  #}

  tags = {
    Name = "project-h-rt"
  }
}

resource "aws_route_table_association" "project_h_rt_association_1" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.project_h_rt.id
}

resource "aws_route_table_association" "project_h_rt_association_2" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.project_h_rt.id
}
 
# Route rule create
resource "aws_route" "project_h_rule" {
  route_table_id          = aws_route_table.project_h_rt.id
  destination_cidr_block  = "0.0.0.0/0"
  gateway_id              = aws_internet_gateway.igw.id
}

# Load Balancer create
resource "aws_elb" "project-h-lb" {
  name               = "project-h-lb"
  availability_zones = ["ap-northeast-2a", "ap-northeast-2c"]

  access_logs {
    bucket        = "project_h_bucket"
    bucket_prefix = "bar"
    interval      = 60
  }

  listener {
    instance_port     = 8000
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  listener {
    instance_port      = 8000
    instance_protocol  = "http"
    lb_port            = 443
    lb_protocol        = "https"
    ssl_certificate_id = ""
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:8000/"
    interval            = 30
  }

  instances                   = i-0cb9d2f1dc93e55cc
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags = {
    Name = "project-h-elb"
  }
}