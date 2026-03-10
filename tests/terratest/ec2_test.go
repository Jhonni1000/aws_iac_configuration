package test

import (
	"context"
	"fmt"
	"log"
	"testing"
	"time"

	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/ec2"
	"github.com/aws/aws-sdk-go-v2/service/sts"
	"github.com/gruntwork-io/terratest/modules/terraform"
)

func getCredentials() {

	cfg, err := config.LoadDefaultConfig(context.TODO())
	if err != nil {
		log.Fatalf("unable to load AWS config, %v", err)
	}

	client := sts.NewFromConfig(cfg)

	caller, err := client.GetCallerIdentity(context.TODO(), &sts.GetCallerIdentityInput{})
	if err != nil {
		log.Fatalf("Couldn't get caller credentials %v", err)
	}

	fmt.Println("Caller Identity %s", *caller.Arn)
}

func getInstanceState(instanceId string, awsRegion string) {
	cfg, err := config.LoadDefaultConfig(context.TODO(), config.WithRegion(awsRegion))
	if err != nil {
		log.Fatalf("Unable to load AWS config %v", err)
	}

	ec2Client := ec2.NewFromConfig(cfg)

	maxRetries := 10
	sleepBetweenRetries := 30 * time.Second

	var state string

	for i := 0; i < maxRetries; i++ {

		resp, err := ec2Client.DescribeInstances(context.TODO(), &ec2.DescribeInstancesInput{
			InstanceIds: []string{instanceId},
		})
		if err != nil {
			log.Fatalf("DescribeInstance Failed %v", err)
		}

		state = string(resp.Reservations[0].Instances[0].State.Name)

		log.Printf("Attempt %d: EC2 instance %s state = %s", i+1, instanceId, state)

		if state == "running" {
			log.Printf("Instance is running")
			break
		}

		time.Sleep(sleepBetweenRetries)
	}

	if state != "running" {
		log.Fatalf("EC2 instance %s did not reach 'running' state after %d retries", instanceId, maxRetries)
	}
}

func TestServiceCatalogEC2(t *testing.T) {

	getCredentials()

	terraformOptions := &terraform.Options{
		TerraformDir: "./../terraform",
	}

	defer terraform.Destroy(t, terraformOptions)

	terraform.InitAndApply(t, terraformOptions)

	instanceId := terraform.Output(t, terraformOptions, "instance_id")
	awsRegion := "eu-north-1"

	getInstanceState(instanceId, awsRegion)
}
