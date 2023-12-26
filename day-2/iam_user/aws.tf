provider "aws" {
  region  = "us-east-1"
  profile = "sandbox"
}


resource "aws_iam_user" "lb" {
  name  = "iam_user_${count.index}"
  count = 3
  path  = "/system/"
}

output "arns" {
  value = aws_iam_user.lb[*].arn
}
