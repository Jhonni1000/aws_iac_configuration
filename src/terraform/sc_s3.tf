resource "aws_s3_bucket" "cfn_bucket" {
  bucket = "servicecatalog-templates-12345"
  acl    = "private"
}

resource "aws_s3_bucket_object" "ec2_template" {
  bucket = aws_s3_bucket.cfn_bucket.id
  key    = "ec2_product_v1.yml.tpl"
  acl    = "private"

  content = templatefile("${path.module}/scripts/ec2_product_v1.yml.tpl", { ami_id = data.aws_ami.ami_latest.id })
}