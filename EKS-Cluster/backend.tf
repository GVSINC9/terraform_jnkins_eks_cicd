terraform {
  backend "s3" {
    bucket = "gvs-s3bucket-aug31"
    key    = "ekscluster/terraform.tfstate"
    region = "us-east-1"
  }
}