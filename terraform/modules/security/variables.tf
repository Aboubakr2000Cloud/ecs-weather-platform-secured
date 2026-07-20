variable "account_id" {
  description = "AWS Account ID"
  type        = string
}
variable "name_prefix" { type = string }
variable "ecs_execution_role_arn" { type = string }

variable "ecs_task_role_arn" { type = string }
variable "db_host" { type = string }
variable "db_name" { type = string }
variable "db_username" { type = string }
variable "common_tags" {
  type = map(string)
}

