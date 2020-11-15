resource "aws_s3_bucket" "project_h_bucket" {
  bucket = "devops-project-h"
  acl    = "log-delivery-write"

  tags = {
    Name  = "devops-project-h-bucket"
  }
}