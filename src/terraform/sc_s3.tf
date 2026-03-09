# locals {
#   ec2_product_versions = {
#     v1 = "ec2_product_v1.yml.tpl"
#     v2 = "ec2_product_v2.yml.tpl"
#   }
# }

# resource "aws_s3_bucket" "cfn_bucket" {
#   bucket = "servicecatalog-templates-123456"
# }

# resource "aws_s3_bucket_object" "ec2_template_initial_version" {
#   bucket = aws_s3_bucket.cfn_bucket.id
#   key    = "ec2/initial_version/ec2_product.yml"
#   acl    = "private"

#   content = file("${path.module}/scripts/ec2_product_initial_version.yml.tpl")
# }

# resource "aws_s3_bucket_object" "ec2_template" {
#   for_each = local.ec2_product_versions

#   bucket = aws_s3_bucket.cfn_bucket.id
#   key    = "ec2/${each.key}/ec2_product.yml"
#   acl    = "private"

#   content = templatefile("${path.module}/scripts/${each.value}", {
#     ami_id = data.aws_ami.ami_latest.id
#   })
# }

# data "aws_iam_policy_document" "s3_policy" {
#   statement {
#     principals {
#       type        = "Service"
#       identifiers = ["servicecatalog.amazonaws.com"]
#     }

#     actions = ["s3:GetObject"]

#     resources = [
#       "${aws_s3_bucket.cfn_bucket.arn}/*"
#     ]
#   }
# }

# resource "aws_s3_bucket_policy" "s3_policy" {
#   bucket = aws_s3_bucket.cfn_bucket.id
#   policy = data.aws_iam_policy_document.s3_policy.json
# }


module "ec2_service_catalog_product" {
  source = "./modules/ec2_product"
  portfolio_name = "EC2-Portfolio"
  product_owner = "OPAKI"
  product_name = "Provisioned-EC2"
  template_bucket_name = "servicecatalog-templates-123456"
  principal_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
  launch_role_name = "sc_launch_role"
  template_vars = {}
  initial_template_file = "${path.module}/scripts/ec2_product_initial_version.yml.tpl"
  ec2_product_versions = {
    v1 = "${path.module}/scripts/ec2_product_v1.yml.tpl",
    v2 = "${path.module}/scripts/ec2_product_v2.yml.tpl",
    v3 = "${path.module}/scripts/ec2_product_v3.yml.tpl",
    v4 = "${path.module}/scripts/ec2_product_v4.yml.tpl"
  }
}