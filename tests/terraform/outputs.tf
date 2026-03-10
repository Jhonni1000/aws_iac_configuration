output "instance_id" {
  value = [
    for o in aws_servicecatalog_provisioned_product.ec2_sc_test.outputs : o.value 
    if o.key == "InstanceId"
  ][0]
}