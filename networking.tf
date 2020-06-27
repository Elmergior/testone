# Create a VPC to launch our instances into
resource "aws_vpc" "default" {
  cidr_block = "10.0.0.0/16"
}

# Create an internet gateway to give our subnet access to the outside world
resource "aws_internet_gateway" "default" {
  vpc_id = aws_vpc.default.id
}

# Grant the VPC internet access on its main route table
resource "aws_route" "internet_access" {
  route_table_id         = aws_vpc.default.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.default.id
}

# Create a subnet to launch our instances into
resource "aws_subnet" "nginx-subnet" {
  vpc_id            = aws_vpc.default.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = data.aws_availability_zones.available.names[0]
}

# Create a subnet to launch our instances into
resource "aws_subnet" "apache-subnet" {
  vpc_id            = aws_vpc.default.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = data.aws_availability_zones.available.names[1]
}

# Create a subnet to launch our ALB into
resource "aws_subnet" "testone_alb_subnet" {
  vpc_id                  = aws_vpc.default.id
  cidr_block              = "10.0.2.0/28"
  map_public_ip_on_launch = true
}

# A security group for the ALB so it is accessible via the web
resource "aws_security_group" "alb" {
  name   = "testone_alb"
  vpc_id = aws_vpc.default.id
  # HTTP access from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Our default security group to access the instances over SSH
resource "aws_security_group" "default" {
  name   = "testone_ec2_sg"
  vpc_id = aws_vpc.default.id

  # SSH access from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # HTTP access from the VPC
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }
  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_key_pair" "auth" {
  key_name   = var.key_name
  public_key = file(var.public_key_path)
}