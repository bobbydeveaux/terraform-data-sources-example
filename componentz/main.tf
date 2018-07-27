provider "aws" {
  region = "us-west-1"
}

resource "aws_iam_role" "role" {
  count = "${1 - signum(length(data.aws_iam_role.selected.name))}"
  name = "${data.aws_iam_role.selected.name}"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": {
    "Effect": "Allow",
    "Principal": {"Service": "lambda.amazonaws.com"},
    "Action": "sts:AssumeRole"
  }
}
EOF
}

data "aws_iam_role" "selected" {
  name = "lambda-role-3"
}