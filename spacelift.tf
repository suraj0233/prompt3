resource "spacelift_stack" "aws_account_integration" {
  name                    = "aws-account-integration"
  repository             = "your-terraform-repo"  # Replace with your actual repository
  branch                 = "main"
  project_root           = "stacks/account-integration"
  manage_state           = true
  enable_local_preview   = true
  
  # This makes the stack administrative, so it can create contexts
  administrative         = true
  
  # Show this stack in the UI as a template that can be used multiple times
  template              = true
  
  labels = [
    "aws-integration",
    "template"
  ]
}

# Allow developers to trigger this stack
resource "spacelift_policy" "stack_trigger" {
  name = "allow-developer-trigger-integration"
  body = <<EOT
package spacelift

trigger {
    input.request.type == "TRIGGER"
}
EOT
  type = "TRIGGER"
}

resource "spacelift_policy_attachment" "stack_trigger" {
  policy_id = spacelift_policy.stack_trigger.id
  stack_id  = spacelift_stack.aws_account_integration.id
}
