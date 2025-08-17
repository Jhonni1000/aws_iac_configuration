resource "aws_s3_bucket" "cfn_bucket" {
  bucket = "servicecatalog-templates-12345"
  acl    = "private"
}

resource "aws_s3_bucket_object" "ec2_template" {
  bucket = aws_s3_bucket.cfn_bucket.id
  key    = "ec2-product.yaml"
  source = "/scripts/ec2_product_v1.yml.tpl"

  content = templatefile("ec2-product.yaml.tpl", {
    ami_id = data.aws_ami.ami_latest.id
  })
}