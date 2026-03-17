variable "project_name" {
  type        = string
  default     = "discover-egypt"
  description = "Base project name used for AWS resources."
}

variable "environment" {
  type        = string
  default     = "dev"
  description = "Deployment environment."
}

variable "aws_region" {
  type        = string
  default     = "eu-central-1"
  description = "Primary AWS region for API and media services."
}
