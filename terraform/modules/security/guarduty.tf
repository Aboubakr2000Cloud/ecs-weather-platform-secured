resource "aws_guardduty_detector" "this" {
  enable = true

  datasources {
    s3_logs {
      enable = true
    }
  }

  tags = merge(
    var.common_tags,
    {
      Name = var.name_prefix
    }
  )
}
