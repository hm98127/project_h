resource "aws_vpc" "provider" {
  cidr_block       = "10.0.0.0/16"

  tags = {
    Name = "project-h-vpc"
  }
}
resource "aws_subnet" "first_subnet" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"

  availability_zone = "ap-northeast-2a"

  tags = {
    Name = "project-h-1"
  }
}

resource "aws_subnet" "second_subnet" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.2.0/24"

  availability_zone = "ap-northeast-2b"

  tags = {
    Name = "project-h-2"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "provider"
  }
}

resource "aws_route_table" "route_table" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "provider"
  }
}

resource "aws_route_table_association" "route_table_association_1" {
  subnet_id      = aws_subnet.first_subnet.id
  route_table_id = aws_route_table.route_table.id
}

resource "aws_route_table_association" "route_table_association_2" {
  subnet_id      = aws_subnet.second_subnet.id
  route_table_id = aws_route_table.route_table.id
}