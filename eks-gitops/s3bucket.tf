terraform {
  backend "s3" {
    bucket = "<Bucket Name>"
    key    = "terraform.tfstate"
    region = "us-west-2"
	access_key = "<Access Key>"
    secret_key = "<Secret Key>"
  }
}