# resource "aws_ssm_parameter" "ec2_ami" {
#     name = "/amis/ec2/ubuntu_ami"
#     type = "String"
#     description = "Packer EC2 Ubuntu AMI"
#     overwrite = true
#     value = var.ec2_ami
# }