resource "aws_s3_bucket" "cfn_bucket" {
  bucket = "servicecatalog-templates-12345"
}

resource "aws_s3_bucket_object" "ec2_template" {
  bucket = aws_s3_bucket.cfn_bucket.id
  key    = "ec2_product_v1.yml"
  acl    = "private"

  content = templatefile("${path.module}/scripts/ec2_product_v1.yml.tpl", {
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
