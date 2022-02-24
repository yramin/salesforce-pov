resource "aws_vpc" "vpc" {
  cidr_block = "10.12.0.0/16"
  tags = {
    Name = "sharedsvcsdr12"
  }
}

resource "aws_subnet" "subnet" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "10.12.0.0/24"
  tags = {
    Name = "sharedsvcsdr12-subnet"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "sharedsvcsdr12-igw"
  }
}

resource "aws_route_table" "rtb" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "sharedsvcsdr12-rtb"
  }
}

resource "aws_route_table_association" "rtb_association" {
  subnet_id      = aws_subnet.subnet.id
  route_table_id = aws_route_table.rtb.id
}
