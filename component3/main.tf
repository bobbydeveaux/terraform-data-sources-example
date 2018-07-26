provider "aws" {
  region = "eu-west-1"
}

data "aws_ami" "nat_ami" {
  most_recent      = true
  executable_users = ["self"]
}

data "aws_vpc" "selected" {
  filter {
    name   = "tag:Name"
    values = ["my-vpc"]
  }
}

data "aws_security_groups" "selected" {
  filter {
    name = "tag:Name",
    values = ["web-server"]
  }

  filter {
    name   = "vpc-id"
    values = ["${data.aws_vpc.selected.id}"]
  }
}

data "aws_subnet" "selected" {
  vpc_id = "${data.aws_vpc.selected.id}"
  filter {
    name = "tag:Name"
    values = ["my-vpc-private-eu-west-1a"]
  }
}

module "ec2_cluster" {
  source = "terraform-aws-modules/ec2-instance/aws"

  name           = "my-cluster"
  instance_count = 5
  
  ami                    = "${data.aws_ami.nat_ami.id}"
  instance_type          = "t2.micro"
  monitoring             = true
  vpc_security_group_ids = "${data.aws_security_groups.selected.ids}"
  subnet_id              = "${data.aws_subnet.selected.id}"

  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}