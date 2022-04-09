terraform {
  backend "s3" {
    bucket = "mymamanbucket"
    key    = "tfstate"
    region = "us-east-1"
  }
}