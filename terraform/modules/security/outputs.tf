output "kms_key_arn" {
  value = aws_kms_key.app.arn
}

output "kms_key_id" {
  value = aws_kms_key.app.key_id
}

output "db_user_parameter_arn" {
  value = aws_ssm_parameter.db_user.arn
}

output "db_host_parameter_arn" {
  value = aws_ssm_parameter.db_host.arn
}

output "db_name_parameter_arn" {
  value = aws_ssm_parameter.db_name.arn
}

output "db_port_parameter_arn" {
  value = aws_ssm_parameter.db_port.arn
}
