data "aws_ami" "packer_ami" {
  most_recent = true
  owners = [ "self" ]

  filter {
    name = "OS"
    values = ["linux"]
  }
}

data "aws_caller_identity" "current" {}