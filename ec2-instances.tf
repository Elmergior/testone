# Create key paris to connect to instances
resource "aws_key_pair" "auth" {
  key_name   = var.key_name
  public_key = file(var.public_key_path)
}

# Create NGINX instance
resource "aws_instance" "ngnix-ec2" {
  connection {
    user        = "ubuntu"
    host        = self.public_ip
    private_key = file(var.private_key_path)
  }
  ami                         = lookup(var.amis, var.region)
  instance_type               = var.instance_type
  vpc_security_group_ids      = [aws_security_group.default.id]
  subnet_id                   = aws_subnet.nginx-subnet.id
  key_name                    = aws_key_pair.auth.id
  associate_public_ip_address = true
  provisioner "remote-exec" {
    inline = [
      "sudo apt-get -y update",
      "sudo apt-get -y install nginx",
      "sudo service nginx start",
    ]
  }
}

# Attach NGINX instance to ALB group
resource "aws_lb_target_group_attachment" "testone_alb_attach_nginx" {
  target_group_arn = aws_lb_target_group.testone-tg.arn
  target_id        = aws_instance.ngnix-ec2.id
  port             = 80
}

# Create Apache instance
resource "aws_instance" "apache-ec2" {
  connection {
    user        = "ubuntu"
    host        = self.public_ip
    private_key = file(var.private_key_path)
  }
  ami           = lookup(var.amis, var.region)
  instance_type = var.instance_type
  provisioner "remote-exec" {
    inline = [
      "sudo apt-get -y update",
      "sudo apt-get -y -f install apache2"
    ]
  }
  vpc_security_group_ids      = [aws_security_group.default.id]
  subnet_id                   = aws_subnet.nginx-subnet.id
  key_name                    = aws_key_pair.auth.id
  associate_public_ip_address = true
}

# Attach Apache instance to ALB group
resource "aws_lb_target_group_attachment" "testone_alb_attach_apache" {
  target_group_arn = aws_lb_target_group.testone-tg.arn
  target_id        = aws_instance.apache-ec2.id
  port             = 80
}