variable "environment" {
  description = "Github environment"
}

variable "region" {
  description = "AWS Region"
  default     = "eu-north-1"
}

variable "ec2_ami" {
  description = "Parmeter store EC2 ami"
  type = string
}