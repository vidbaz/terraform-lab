terraform {
  backend "s3" {
    bucket  = "terraform-state-vidbaz"
    key     = "terraform-labs/budget.tfstate"
    region  = "us-west-2"
    encrypt = true
  }
}
