package test

import (
    "testing"
    "os"
    "github.com/gruntwork-io/terratest/modules/aws"
    "github.com/stretchr/testify/assert"
)

func TestAWSResourcesInAccount(t *testing.T) {
    // Specify the AWS region where you are creating resources.
    awsRegion := "us-east-1"

    // Specify the expected AWS account ID.
    expectedAccountID := "377308807353" // Replace with your actual AWS account ID.

    // Retrieve the AWS session using your AWS credentials.
    awsOptions := aws.NewOptions(awsRegion)
    awsSession, err := aws.NewSession(awsOptions)
    if err != nil {
        t.Fatalf("Failed to create AWS session: %v", err)
    }

    // Get the AWS account ID from the session.
    accountID, err := aws.GetAccountIDE(t, awsRegion, awsSession)
    if err != nil {
        t.Fatalf("Failed to get AWS account ID: %v", err)
    }

    // Check if the retrieved AWS account ID matches the expected value.
    assert.Equal(t, expectedAccountID, accountID, "AWS account ID does not match the expected value")

    // Now, you can use Terratest to deploy and test AWS resources in this account.
    // Implement your resource deployment and testing logic here.
}

func TestMain(m *testing.M) {
    // Set up any necessary AWS credentials and configuration here.

    // Run the tests.
    exitCode := m.Run()

    // Clean up or perform any necessary teardown here.

    // Exit with the appropriate exit code.
    os.Exit(exitCode)
}
