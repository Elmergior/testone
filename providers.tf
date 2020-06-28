# Provider
provider "aws" {
  shared_credentials_file = "~/.aws/credentials"
  profile                 = "testone"
  region                  = var.region
  version                 = "~> 2.68"
}