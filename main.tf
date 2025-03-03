terraform {
  required_providers {
    spacelift = {
      source  = "spacelift-io/spacelift"
      version = "~> 1.0"
    }
  }
}

# This variable will be presented as a form field in the Spacelift UI
variable "aws_account_id" {
  description = "Your AWS Account ID (12 digits)"
  type        = string
  
  validation {
    condition     = can(regex("^\\d{12}$", var.aws_account_id))
    error_message = "AWS Account ID must be exactly 12 digits."
  }
}

module "aws_integration" {
  source         = "../../modules/aws-account-integration"
  aws_account_id = var.aws_account_id
}

output "next_steps" {
  value = <<EOT
✅ AWS Account ${var.aws_account_id} has been successfully integrated with Spacelift!

Next steps:
1. Create a new stack in Spacelift
2. Attach the context "${module.aws_integration.context_name}" to your stack
3. Your stack will now have access to AWS account ${var.aws_account_id}
EOT
}
