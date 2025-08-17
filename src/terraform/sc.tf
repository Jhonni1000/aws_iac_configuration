resource "aws_servicecatalog_product" "ec2_product" {
  name  = "Provisioned-EC2"
  type  = "CLOUD_FORMATION_TEMPLATE"
  owner = "OPAKI"

  provisioning_artifact_parameters {
    name         = "v1"
    description  = "Initial version"
    template_url = "https://servicecatalog-templates-12345/ec2_product_v1.yml.tpl"
  }
}
