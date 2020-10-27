provider "aws" {
 region = "eu-north-1"
}

resource "aws_instance" "Instance" {
  ami = "ami-008dea09a148cea39"
  instance_type = "t3.micro"
  associate_public_ip_address = true
  key_name = "ssh_key"
  count = "1"
  vpc_security_group_ids = [aws_security_group.ssh_access.id]

connection {
  type = "ssh"
  port = "22"
  user = "ubuntu"
  private_key = file("/root/.ssh/id_rsa")
  timeout = "1m"
  agent = "true"
}

}
resource "aws_key_pair"  "ssh_key"{
  key_name = "ssh_key"
  public_key =  file("/root/.ssh/id_rsa.pub")
}
resource "aws_security_group" "ssh_access" {
  name = "ssh access for instance"

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  =  "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
