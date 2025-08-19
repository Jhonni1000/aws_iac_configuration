resource "aws_servicecatalog_product" "ec2_product" {
  name  = "Provisioned-EC2"
  type  = "CLOUD_FORMATION_TEMPLATE"
  owner = "OPAKI"

  provisioning_artifact_parameters {
    name         = "v1"
    description  = "Initial version"
    template_url = "https://servicecatalog-templates-12345.s3.eu-north-1.amazonaws.com/ec2_product_v1.yml"
    type        = "CLOUD_FORMATION_TEMPLATE"
  }

  depends_on = [ aws_s3_bucket_object.ec2_template ]
}

resource "aws_servicecatalog_portfolio" "ec2_product" {
  name        = "EC2-Portfolio"
  description = "Portfolio for EC2 products"
  provider_name = "OPAKI"
}

resource "aws_servicecatalog_principal_portfolio_association" "example" {
  portfolio_id  = aws_servicecatalog_portfolio.ec2_product.id
  principal_arn = "arn:aws:iam::738605694254:role/aws-reserved/sso.amazonaws.com/eu-north-1/AWSReservedSSO_AdministratorAccess_ae92e0dac5f28572"
  principal_type = "IAM"
}
