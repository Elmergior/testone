resource "aws_instance" "ngnix-ec2" {
  ami           = lookup(var.amis, var.region)
  instance_type = var.instance_type
  provisioner "remote-exec" {
    inline = [
      "sudo apt-get -y update",
      "sudo apt-get -y install nginx",
      "sudo service nginx start",
    ]
  }
  vpc_security_group_ids = [aws_security_group.default.id]
  subnet_id              = aws_subnet.nginx-subnet.id
  key_name               = aws_key_pair.auth.id
}

resource "aws_lb_target_group_attachment" "testone_alb_attach_nginx" {
  target_group_arn = aws_lb_target_group.testone-tg.arn
  target_id        = aws_instance.ngnix-ec2.id
  port             = 80
}

resource "aws_instance" "apache-ec2" {
  ami           = lookup(var.amis, var.region)
  instance_type = var.instance_type
  provisioner "remote-exec" {
    inline = [
      "sudo apt-get -y update",
      "sudo apt-get -y install apache2",
      "sudo service apache2 start",
    ]
  }
  vpc_security_group_ids = [aws_security_group.default.id]
  subnet_id              = aws_subnet.apache-subnet.id
  key_name               = aws_key_pair.auth.id
}

resource "aws_lb_target_group_attachment" "testone_alb_attach_apache" {
  target_group_arn = aws_lb_target_group.testone-tg.arn
  target_id        = aws_instance.apache-ec2.id
  port             = 80
}