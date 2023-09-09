package test

import (
    "testing"
    "github.com/gruntwork-io/terratest/modules/aws"
    "github.com/gruntwork-io/terratest/modules/terraform"
    "github.com/stretchr/testify/assert"
)

func TestTerraformRegionAndAccountID(t *testing.T) {
    t.Parallel()

    // Set up options for Terraform initialization and deployment
    terraformOptions := &terraform.Options{
        // Specify the path to your Terraform code
        TerraformDir: "../terraform-manager-infra",
    }

    // Defer the cleanup of resources until the test is complete
    defer terraform.Destroy(t, terraformOptions)

    // Initialize and apply the Terraform configuration
    terraform.InitAndApply(t, terraformOptions)

    // Retrieve the AWS region and account ID
    //region := aws.GetRegion(t)
    accountID := aws.GetAccountId(t)
	//vpcID := terraform.Output(t, terraformOptions, "vpc_id")

    // Check if the region matches the expected region
    //expectedRegion := "us-west-2"  // Set your expected AWS region
    //assert.Equal(t, expectedRegion, region)

    // Check if the account ID matches the expected account ID
    expectedAccountID := "377308807353"  // Set your expected AWS account ID
    assert.Equal(t, expectedAccountID, accountID)

	//vpc := aws.GetVpcById(t, vpcID)
	//assert.Equal(t, "10.0.0.0/16", vpc.CidrBlock)
}
