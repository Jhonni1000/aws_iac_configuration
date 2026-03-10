resource "aws_servicecatalog_product" "ec2_product" {
  name  = var.product_name
  type  = "CLOUD_FORMATION_TEMPLATE"
  owner = var.product_owner

  provisioning_artifact_parameters {
    name         = "v1"
    description  = "Initial version"
    template_url = "https://servicecatalog-templates-123456.s3.eu-north-1.amazonaws.com/ec2/initial_version/ec2_product.yml"
    type         = "CLOUD_FORMATION_TEMPLATE"
  }

  depends_on = [aws_s3_bucket_object.ec2_template_initial_version]
}

resource "aws_servicecatalog_provisioning_artifact" "ec2_product" {
  for_each = var.ec2_product_versions

  product_id   = aws_servicecatalog_product.ec2_product.id
  name         = each.key
  template_url = "https://${aws_s3_bucket.cfn_bucket.bucket}.s3.${var.region}.amazonaws.com/ec2/${each.key}/ec2_product.yml"
  type         = "CLOUD_FORMATION_TEMPLATE"

  depends_on = [aws_s3_bucket_object.ec2_template]
}


resource "aws_servicecatalog_portfolio" "ec2_product" {
  name          = var.portfolio_name
  description   = "Portfolio for EC2 products"
  provider_name = var.product_owner
}

resource "aws_servicecatalog_principal_portfolio_association" "ec2_product" {
  for_each = toset(var.principal_arn)
  portfolio_id   = aws_servicecatalog_portfolio.ec2_product.id
  principal_arn  = each.value
  principal_type = "IAM"
}

resource "aws_servicecatalog_product_portfolio_association" "portfolio_association" {
  portfolio_id = aws_servicecatalog_portfolio.ec2_product.id
  product_id   = aws_servicecatalog_product.ec2_product.id
}

resource "aws_servicecatalog_constraint" "launch_role" {
  description  = "Launch Role Constraints"
  product_id   = aws_servicecatalog_product.ec2_product.id
  type         = var.constraint_type
  portfolio_id = aws_servicecatalog_portfolio.ec2_product.id
  parameters = jsonencode({
    "LocalRoleName" : var.launch_role_name
  })
}