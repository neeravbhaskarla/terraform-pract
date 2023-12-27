provider "aws" {
    region = "ap-south-1"
}

data "aws_ami" "linux_ami" {
    most_recent = true
    owners = ["amazon"]

    filter {
      name = "name"
      values = ["amzn2-ami-hvm*"]
    }
}

resource "aws_instance" "myec2" {
    instance_type = "t2.micro"
    # ami = data.aws_ami.linux_ami.id
    ami = "ami-08fe36427228eddc4"

    tags = {
        Name = "Env Instance"
    }

    lifecycle {
        ignore_changes = [tags]
        create_before_destroy = true
        prevent_destroy = true
    }
}


resource "aws_instance" "instances"{
    for_each = toset(["devops-instance", "dev-instance", "prod-instance", "test-instance"])
    ami = data.aws_ami.linux_ami.id
    instance_type = "t2.micro"
    tags = {
        Name = each.value
    }
}
