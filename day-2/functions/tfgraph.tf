provider "aws" {
  region  = "us-east-1"
  profile = "sandbox"
}

variable "sg_ports" {
  type        = list(number)
  description = "Security group ports"
  default     = [8000, 8001, 8002, 8003]
}

resource "aws_security_group" "sg_group" {
  name        = "myEc2InstanceSG"
  description = "Security group for ingress from 800[0-3]"
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

data "aws_ami" "linux-ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

resource "aws_instance" "myec2" {
  ami           = data.aws_ami.linux-ami.id
  instance_type = "t2.micro"
  tags = {
    Name = "Sg-practise-instance"
  }
}

resource "aws_network_interface_sg_attachment" "ec2_sgattach" {
  security_group_id    = aws_security_group.sg_group.id
  network_interface_id = aws_instance.myec2.primary_network_interface_id
}

variable "instance_envs" {
  type    = list(string)
  default = ["dev-instance", "test-instance", "prod-instance"]
}

resource "aws_instance" "instance-env" {
  ami           = data.aws_ami.linux-ami.id
  instance_type = "t2.medium"
  tags = {
    Name = "${var.instance_envs[count.index]}"
  }
  count = 3
}

locals {
  ami            = data.aws_ami.linux-ami.id
  instance_types = ["t2.nano", "t2.micro", "t2.small", "t2.medium", "t2.large", "t2.xlarge", "t2.2xlarge"]
  tags = {
    Name = "practise-instance"
    req  = "practise"
  }
}
variable "firstTime" {
    type = bool
    default = false
}
resource "aws_instance" "instance-1" {
  ami           = local.ami
  instance_type = var.firstTime ? "t2.micro": local.instance_types[count.index]
  count         = 7
  tags          = local.tags
}

output "ec2-instances-info" {
    value = zipmap(aws_instance.instance-1[*].arn, aws_instance.instance-1[*].public_dns)
}
