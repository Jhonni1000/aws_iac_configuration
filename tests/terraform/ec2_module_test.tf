resource "aws_servicecatalog_provisioned_product" "ec2_sc_test" {
    name = "ec2_test_instance"
    product_name = "Provisioned-EC2"
    provisioning_artifact_name = "v3"

    provisioning_parameters {
        key = "EC2Storage"
        value = "30"
    }

    provisioning_parameters {
        key = "InstanceType"
        value = "t3.micro"
    }

    provisioning_parameters {
        key  = "SubnetCfg"
        value = "subnet-076dc7b283fbe48f2"
    }

    provisioning_parameters {
        key = "VPCConfig"
        value = "vpc-0734d8f68d2ff0675"
    }
}