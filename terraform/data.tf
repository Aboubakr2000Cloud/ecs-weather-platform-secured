data "aws_caller_identity" "current" {}
data "aws_s3_bucket" "terraform_state" {
  bucket = "my-abou-terraform-state-bucket"
}
