terraform {
  backend "s3" {
    bucket  = "bucket-toronto-steven"
    key     = "migration/ec2.tfstate"
    region  = "ca-central-1"
    encrypt = true
    profile = "stevenz"
  }
}
