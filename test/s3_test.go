package test

import (
	"strings"
	"fmt"
	"testing"

	"github.com/gruntwork-io/terratest/modules/aws"
	"github.com/gruntwork-io/terratest/modules/terraform"
)

// An example of how to test the Terraform module in examples/terraform-aws-s3-example using Terratest.
func TestTerraformAwsS3Example(t *testing.T) {
	t.Parallel()

	awsRegion := "us-west-2"

	// Construct the terraform options with default retryable errors to handle the most common retryable errors in
	// terraform testing.
	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: "../",

		// Variables to pass to our Terraform code using -var options
		Vars: map[string]interface{}{
			"bucket_name":        "bucket-mijha-20222",
			"tag_bucket_environment": "dev",
			"with_policy":            "true",
		},

		// Environment variables to set when running Terraform
		EnvVars: map[string]string{
			"AWS_DEFAULT_REGION": "us-west-2",
		},
	})

	// At the end of the test, run `terraform destroy` to clean up any resources that were created
	defer terraform.Destroy(t, terraformOptions)

	// This will run `terraform init` and `terraform apply` and fail the test if there are any errors
	terraform.InitAndApply(t, terraformOptions)

	// Run `terraform output` to get the value of an output variable
	bucketID := terraform.Output(t, terraformOptions, "bucket_id")

	objectIDs := terraform.Output(t, terraformOptions, "object_ids")
	res1 := strings.Replace(objectIDs, "[", "", -1)
	res2 := strings.Replace(res1, "]", "", -1)
	res3 := strings.Fields(res2)

	fmt.Println(objectIDs)

	for i, objectID := range res3 {
		fmt.Println(i, " => ", objectID)
		objectContent := aws.GetS3ObjectContents(t,awsRegion, bucketID, objectID)

		fmt.Println("objectContent => ", objectContent)
	}

}

