provider "aws" {
  region  = "eu-west-3"
  profile = "ahmed"
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "tls_private_key" "instance_tls_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "instance_key_pair" {
  key_name   = "ubuntu-instance-key"
  public_key = tls_private_key.instance_tls_key.public_key_openssh
}

resource "aws_security_group" "instance_sg" {
  name        = "my_sg"
  description = "Allow SSH inbound traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow SSH from anywhere, change for production
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Replace with your specific IP range if desired
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
  key_name        = aws_key_pair.instance_key_pair.key_name
  vpc_security_group_ids = [aws_security_group.instance_sg.id]

  provisioner "local-exec" {
    command = "echo ${aws_instance.web.public_ip} > ip_address.txt"
  }
}

resource "local_file" "private_key" {
  content  = tls_private_key.instance_tls_key.private_key_pem
  filename = "${path.module}/id_rsa"
  file_permission = "0600"
}

output "instance_id" {
  value = aws_instance.web.id
}

output "public_ip" {
  value = aws_instance.web.public_ip
}

output "public_dns" {
  value = aws_instance.web.public_dns
}

output "private_key_path" {
  value = local_file.private_key.filename
}
