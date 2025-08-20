locals {
  ec2_product_versions = {
    v1 = "ec2_product_v1.yml.tpl"
    v2 = "ec2_product_v2.yml.tpl"
  }
}

resource "aws_s3_bucket" "cfn_bucket" {
  bucket = "servicecatalog-templates-12345"
}

resource "aws_s3_bucket_object" "ec2_template" {
  for_each = local.ec2_product_versions

  bucket = aws_s3_bucket.cfn_bucket.id
  key    = "ec2/${each.key}/ec2_product.yml"
  acl    = "private"

  content = templatefile("${path.module}/scripts/${each.value}", {
    ami_id = data.aws_ami.ami_latest.id
  })
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
