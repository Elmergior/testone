variable region {
  default = "us-east-1"
}

variable amis {
  type = map
  default = {
    "us-east-1" = "ami-0ac80df6eff0e70b5"
    "us-west-2" = "ami-0a63f96e85105c6d3"
  }
}

variable instance_type {
  default = "t2.micro"
}

output address {
  value = aws_lb.testone-alb.dns_name
}

variable key_name {
  default = "testone"
}

variable public_key_path {
  default = "~/.ssh/testonekey.pub"
}

data "aws_availability_zones" "available" {
  state = "available"
}

variable private_key_path {
  default = "~/.ssh/testone.pem"
}
