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
