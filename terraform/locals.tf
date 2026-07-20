locals {
  name_prefix    = "weather-security-${var.environment}"
  monitor_prefix = "ws"-"${var.environment}"
  common_tags    = {
    Project      = "ecs-weather-platform-secured"
    Environment  = var.environment
    ManagedBy    = "terraform"
    Owner        = "Abou"
  }
}


