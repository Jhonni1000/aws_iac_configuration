data "aws_ami" "packer_ami" {
  most_recent = true
  owners = [ "self" ]

  filter {
    name = "name"
    values = ["packer-linux-aws-*"]
  }
}

data "aws_caller_identity" "current" {}