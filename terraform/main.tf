terraform {
  required_version = ">= 0.12"

  backend "s3" {
    bucket  = "jb-terraform-bucket-rails-app-us-east-1"
    key     = "terraform/state.tfstate"
    region  = "us-east-1"
    profile = "ci"
  }
}

provider "aws" {
  region  = "us-east-1"
  profile = "ci"

  default_tags {
    tags = {
      managed-by = "terraform"
    }
  }
}
