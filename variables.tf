# Name of project
variable name {
    default = "testone"
}


# Select Region
variable region {
  default = "us-east-1"
}

# amis map
variable amis {
  type = map
  default = {
    "us-east-1" = "ami-0ac80df6eff0e70b5"
    "us-west-2" = "ami-0a63f96e85105c6d3"
  }
}

# Select instance type
variable instance_type {
  default = "t2.micro"
}

# URL to connect
output address {
  value = aws_lb.testone-alb.dns_name
}

# key name from AWS
variable key_name {
  default = "testone"
}

# Path to public key
variable public_key_path {
  default = "~/.ssh/testone.pub"
}

# Private key path
variable private_key_path {
  default = "~/.ssh/testone.pem"
}

# Availability zones
data "aws_availability_zones" "available" {
  state = "available"
}


