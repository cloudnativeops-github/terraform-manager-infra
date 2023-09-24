terraform {
  backend "s3" {
    bucket         = "myorg-acc-s3-state-bucket"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform_state"
  }
}