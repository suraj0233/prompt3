variable "aws_account_id" {
  description = "AWS Account ID to integrate with Spacelift"
  type        = string
  
  validation {
    condition     = can(regex("^\\d{12}$", var.aws_account_id))
    error_message = "AWS Account ID must be exactly 12 digits."
  }
}

variable "context_name" {
  description = "Name of the Spacelift context to create"
  type        = string
  default     = null
}

locals {
  context_name = var.context_name != null ? var.context_name : "aws-${var.aws_account_id}"
}

# Create a Spacelift context for the AWS account
resource "spacelift_context" "aws_account" {
  name        = local.context_name
  description = "AWS Account Integration for ${var.aws_account_id}"
}

# Create AWS credentials in the context
resource "spacelift_aws_integration" "account" {
  context_id = spacelift_context.aws_account.id
  name       = "aws-integration"
  role_arn   = "arn:aws:iam::${var.aws_account_id}:role/Spacelift"
}

output "context_id" {
  description = "The ID of the created Spacelift context"
  value       = spacelift_context.aws_account.id
}

output "context_name" {
  description = "The name of the created Spacelift context"
  value       = spacelift_context.aws_account.name
}
