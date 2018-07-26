provider "aws" {
  region = "eu-west-1"
}

data "aws_vpc" "selected" {
  filter {
    name   = "tag:Name"
    values = ["my-vpc"]
  }
}

module "web_server_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "web-server"
  description = "Security group for web-server with HTTP ports open within VPC"
  vpc_id      = "${data.aws_vpc.selected.id}"

  ingress_cidr_blocks = ["10.10.0.0/16"]
}
