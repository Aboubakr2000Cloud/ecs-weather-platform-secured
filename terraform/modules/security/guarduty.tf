resource "aws_guardduty_detector" "this" {
  enable = true
  count = var.enable_guardduty ? 1 : 0

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
