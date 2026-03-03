resource "aws_s3_bucket" "cfn_bucket" {
  bucket = var.template_bucket_name
}

resource "aws_s3_bucket_object" "ec2_template_initial_version" {
  bucket = aws_s3_bucket.cfn_bucket.id
  key    = "ec2/initial_version/ec2_product.yml"
  acl    = "private"

  content = file(var.initial_template_file)
}

resource "aws_s3_bucket_object" "ec2_template" {
  for_each = var.ec2_product_versions

  bucket = aws_s3_bucket.cfn_bucket.id
  key    = "ec2/${each.key}/ec2_product.yml"
  acl    = "private"

  content = templatefile(each.value, var.template_vars)
}

data "aws_iam_policy_document" "s3_policy" {
  statement {
    principals {
      type        = "Service"
      identifiers = ["servicecatalog.amazonaws.com"]
    }

    actions = ["s3:GetObject"]

    resources = [
      "${aws_s3_bucket.cfn_bucket.arn}/*"
    ]
  }
}

resource "aws_s3_bucket_policy" "s3_policy" {
  bucket = aws_s3_bucket.cfn_bucket.id
  policy = data.aws_iam_policy_document.s3_policy.json
}
