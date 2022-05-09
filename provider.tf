terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }

  required_version = ">= 0.14.9"
}

#리전 서울
provider "aws" {
  region     = "ap-northeast-2"
  access_key = "Your access key"
  secret_key = "Your sevret key"
}
