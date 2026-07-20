# Execution Role — used by ECS agent
resource "aws_iam_role" "ecs_execution" {
  name = "${local.name_prefix}-ecs-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "ecs-tasks.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_execution" {
  role       = aws_iam_role.ecs_execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# Additional policy for Secrets Manager access
resource "aws_iam_role_policy" "ecs_execution_configuration" {
  name = "configuration-access"
  role = aws_iam_role.ecs_execution.id

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Sid    = "SecretsManagerAccess"
        Effect = "Allow"

        Action = [
          "secretsmanager:GetSecretValue"
        ]

        Resource = [
          aws_secretsmanager_secret.db_password.arn,
          aws_secretsmanager_secret.weather_api_key.arn
        ]
      },
      {
        Sid    = "ParameterStoreAccess"
        Effect = "Allow"

        Action = [
          "ssm:GetParameters"
        ]

        Resource = [
          "arn:aws:ssm:${var.region}:${data.aws_caller_identity.current.account_id}:parameter/${local.name_prefix}/*"
        ]
      }
    ]
  })
}

# Task Role — used by your application code
resource "aws_iam_role" "ecs_task" {
  name = "${local.name_prefix}-ecs-task-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "ecs-tasks.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })
}

# ECS Exec permissions for the task role
resource "aws_iam_role_policy" "ecs_exec" {
  name = "ecs-exec"
  role = aws_iam_role.ecs_task.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "ssmmessages:CreateControlChannel",
        "ssmmessages:CreateDataChannel",
        "ssmmessages:OpenControlChannel",
        "ssmmessages:OpenDataChannel"
      ]
      Resource = "*"
    }]
  })
}

# Secrets Manager secrets
resource "aws_secretsmanager_secret" "db_password" {
  name                    = "${local.name_prefix}/db-password"
  kms_key_id              = module.security.kms_key_arn
  recovery_window_in_days = 0 # immediate deletion (for learning)
}

resource "aws_secretsmanager_secret_version" "db_password" {
  secret_id     = aws_secretsmanager_secret.db_password.id
  secret_string = var.db_password
}

resource "aws_secretsmanager_secret" "weather_api_key" {
  name                    = "${local.name_prefix}/weather-api-key"
  kms_key_id              = module.security.kms_key_arn
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "weather_api_key" {
  secret_id     = aws_secretsmanager_secret.weather_api_key.id
  secret_string = var.weather_api_key
}

resource "aws_iam_role_policy" "custom_metrics" {
  name = "cloudwatch-custom-metrics"
  role = aws_iam_role.ecs_task.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = ["cloudwatch:PutMetricData"]
      Resource = "*"
      Condition = {
        StringEquals = {
          "cloudwatch:namespace" = "WeatherApp"
        }
      }
    }]
  })
}
