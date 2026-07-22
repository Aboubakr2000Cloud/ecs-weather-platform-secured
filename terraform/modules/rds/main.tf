terraform {
  required_version = ">= 1.5"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# ── DB SUBNET GROUP ─────────────────────────────────────────────────────
resource "aws_db_subnet_group" "this" {
  name       = "${var.name_prefix}-db-subnet-group"
  subnet_ids = var.private_subnet_ids
  tags = merge(
    var.common_tags,
    {
      Name = "${var.name_prefix}-db_subnet_group"
    }
  )
}

# ── DB INSTANCE ─────────────────────────────────────────────────────────
resource "aws_db_instance" "this" {
  identifier        = "${var.name_prefix}-db"
  engine            = "mysql"
  instance_class    = var.db_instance_class
  allocated_storage = 20
  storage_type      = "gp3"

  db_name  = var.db_name
  username = var.db_username
  password = var.db_password # from TF_VAR_db_password env var

  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = [var.rds_sg_id]

  multi_az            = false
  publicly_accessible = false

  kms_key_id = var.kms_key_arn

  final_snapshot_identifier = "${var.name_prefix}-final-snapshot"
  skip_final_snapshot       = true
  backup_retention_period   = 1

  auto_minor_version_upgrade = true # auto-patch minor versions
  copy_tags_to_snapshot      = true

  deletion_protection = true
  storage_encrypted   = true

  tags = merge(
    var.common_tags,
    {
      Name = "${var.name_prefix}-db"
    }
  )
}
