resource "aws_s3_bucket" "apps_logs_bucket" {
  bucket = "devopsart-terraform"
  acl    = "log-delivery-write"

  tags = {
    Name        = "devopsart-terraform-101"
  }
}