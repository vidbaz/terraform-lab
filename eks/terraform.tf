terraform {
  backend "s3" {
    bucket  = "terraform-state-vidbaz"
    key     = "terraform-labs/eks.tfstate"
    region  = "us-west-2"
    encrypt = true
  }
}
