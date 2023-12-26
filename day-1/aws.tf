provider "aws" {
  region  = "us-east-1"
  profile = "sandbox"
}

variable "sg_ports" {
  type        = list(number)
  description = "list of ingress ports"
  default     = [8000, 8001, 8002, 8003, 8004, 8005, 8006, 8007]
}

resource "aws_security_group" "sec_1" {
  name        = "Ec2Instance"
  description = "EC2 ingress for 800x ports"
  dynamic "ingress" {
    for_each = var.sg_ports
    iterator = port
    content {
      from_port   = port.value
      to_port     = port.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
}

data "aws_ami" "myami" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

resource "aws_instance" "myec2" {
  ami           = data.aws_ami.myami.id
  instance_type = "t2.micro"
}

resource "aws_network_interface_sg_attachment" "sec_1_myec2" {
  security_group_id    = aws_security_group.sec_1.id
  network_interface_id = aws_instance.myec2.primary_network_interface_id
}

output "network_intefaceId" {
  value = aws_instance.myec2.primary_network_interface_id
}
