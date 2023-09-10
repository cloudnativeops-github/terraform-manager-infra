package test

import (
    "testing"
    "os"
    "github.com/aws/aws-sdk-go/aws/session"
    "github.com/aws/aws-sdk-go/service/sts"
    "github.com/stretchr/testify/assert"
)

func TestAWSAccountID(t *testing.T) {
    // Create an AWS session using your AWS credentials.
    sess, err := session.NewSession()
    if err != nil {
        t.Fatalf("Failed to create AWS session: %v", err)
    }

    // Create an STS (Security Token Service) client to retrieve the account ID.
    svc := sts.New(sess)

    // Use the GetCallerIdentity API to get information about the calling account.
    identity, err := svc.GetCallerIdentity(&sts.GetCallerIdentityInput{})
    if err != nil {
        t.Fatalf("Failed to get caller identity: %v", err)
    }

    // Extract the AWS account ID from the caller identity.
    region := *sess.Config.Region
    accountID := *identity.Account

    // Specify the expected AWS account ID.
    expectedRegion := "us-east-1"
    expectedAccountID := "377308807353" // Replace with your actual AWS account ID.

    // Check if the retrieved AWS account ID matches the expected value.
    assert.Equal(t, expectedRegion, region, "AWS region does not match the expected value")
    assert.Equal(t, expectedAccountID, accountID, "AWS account ID does not match the expected value")
}

func TestMain(m *testing.M) {
    // Set up any necessary AWS credentials and configuration here.

    // Run the tests.
    exitCode := m.Run()

    // Clean up or perform any necessary teardown here.

    // Exit with the appropriate exit code.
    os.Exit(exitCode)
}
