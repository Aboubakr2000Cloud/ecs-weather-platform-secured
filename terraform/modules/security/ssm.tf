terraform {
  required_version = ">= 1.5"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

resource "aws_ssm_parameter" "db_host" {
  name  = "/${var.name_prefix}/db-host"
  type  = "String"
  value = module.rds.db_host

  tags  = merge(
    var.common_tags,
    {
      Name = var.name_prefix
    }
  )
}

resource "aws_ssm_parameter" "db_name" {
  name  = "/${var.name_prefix}/db-name"
  type  = "String"
  value = var.db_name

  tags  = merge(
    var.common_tags,
    {
      Name = var.name_prefix
    }
  )
}

resource "aws_ssm_parameter" "db_port" {
  name  = "/${var.name_prefix}/db-port"
  type  = "String"
  value = "3306"

  tags  = merge(
    var.common_tags,
    {
      Name = var.name_prefix
    }
  )
}

resource "aws_ssm_parameter" "db_user" {
  name  = "/${var.name_prefix}/db-user"
  type  = "String"
  value = var.db_username

  tags  = merge(
    var.common_tags,
    {
      Name = var.name_prefix
    }
  )
}
