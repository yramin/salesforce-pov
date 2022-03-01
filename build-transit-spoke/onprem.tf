provider "aws" {
  alias  = "us-east-1"
  region = "us-east-1"
}

resource "aws_vpc" "onprem_vpc" {
  provider   = aws.us-east-1
  cidr_block = "10.18.0.0/16"
  tags = {
    Name = "onprem"
  }
}

resource "aws_subnet" "onprem_subnet" {
  provider   = aws.us-east-1
  vpc_id     = aws_vpc.onprem_vpc.id
  cidr_block = "10.18.0.0/24"
  tags = {
    Name = "onprem-subnet"
  }
}

resource "aws_internet_gateway" "onprem_igw" {
  provider = aws.us-east-1
  vpc_id   = aws_vpc.onprem_vpc.id
  tags = {
    Name = "onprem-igw"
  }
}

resource "aws_route_table" "onprem_rtb" {
  provider = aws.us-east-1
  vpc_id   = aws_vpc.onprem_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.onprem_igw.id
  }
  tags = {
    Name = "onprem-rtb"
  }
}

resource "aws_route_table_association" "onprem_rtb_association" {
  provider       = aws.us-east-1
  subnet_id      = aws_subnet.onprem_subnet.id
  route_table_id = aws_route_table.onprem_rtb.id
}


resource "aws_security_group" "onprem_sg" {
  provider = aws.us-east-1
  name     = "csr0-security-group"
  vpc_id   = aws_vpc.onprem_vpc.id
  tags = {
    Name = "onprem-security-group"
  }
}

resource "aws_security_group_rule" "onprem_inbound" {
  provider          = aws.us-east-1
  type              = "ingress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.onprem_sg.id
}

resource "aws_security_group_rule" "onprem_outbound" {
  provider          = aws.us-east-1
  type              = "egress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.onprem_sg.id
}

resource "aws_network_interface" "onprem_nic" {
  provider          = aws.us-east-1
  subnet_id         = aws_subnet.onprem_subnet.id
  security_groups   = [aws_security_group.onprem_sg.id]
  source_dest_check = false
  tags = {
    Name = "onprem-nic"
  }
}

resource "aws_eip" "onprem_eip" {
  provider = aws.us-east-1
  vpc      = true
  tags = {
    Name = "onprem-eip"
  }
}

resource "aws_eip_association" "onprem_eip_association" {
  provider             = aws.us-east-1
  network_interface_id = aws_network_interface.onprem_nic.id
  allocation_id        = aws_eip.onprem_eip.id
  depends_on = [
    aws_instance.onprem_csr
  ]
}

resource "aws_instance" "onprem_csr" {
  provider      = aws.us-east-1
  ami           = "ami-0d18f295f92eaca4c"
  instance_type = "t2.medium"
  network_interface {
    network_interface_id = aws_network_interface.onprem_nic.id
    device_index         = 0
  }
  user_data = templatefile("${path.module}/csr/onprem.txt",
    {
      onprem_csr_hostname = "onpremcsr"
      onprem_csr_username = var.onprem_csr_username
      onprem_csr_password = var.onprem_csr_password
    }
  )
  tags = {
    Name = "onprem-csr"
  }
}