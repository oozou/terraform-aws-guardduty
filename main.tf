resource "aws_guardduty_detector" "guardduty" {
  enable                       = true
  finding_publishing_frequency = var.finding_publishing_frequency

  datasources {
    s3_logs {
      enable = var.is_s3_protection_enabled
    }

    malware_protection {
      scan_ec2_instance_with_findings {
        ebs_volumes {
          enable = var.is_malware_protection_enabled
        }
      }
    }
    
    kubernetes {
      audit_logs {
        enable = var.is_kubernetes_protection_enabled
      }
    }


  }
  

  tags = local.tags
}

module "sns_email" {
  source = "git@github.com:oozou/terraform-aws-sns.git?ref=v1.0.1"

  prefix       = var.prefix
  environment  = var.environment
  name         = format("%s-gd", var.name)
  display_name = format("%s-GuardDuty", var.name)

  # KMS
  is_enable_encryption = true
  is_create_kms        = true
  additional_kms_key_policies = [data.aws_iam_policy_document.cwe.json]

  subscription_configurations = {
    email = {
      protocol  = "email"
      addresses = var.is_enabled_notification.email_notify.enable ? var.is_enabled_notification.email_notify.mail_list : []
    }
  }

  sns_permission_configuration = { # Defautl is {}
    allow_eventbridge = {
      pricipal = "events.amazonaws.com"
    }
  }

  tags = local.tags
}


module "eventbridge_mail" {
  source = "git@github.com:oozou/terraform-aws-eventbridge.git?ref=v1.0.1"

  prefix            = var.prefix
  environment       = var.environment
  event_description = "The rule for GuardDuty Notify SNS to Email"
  name              = format("%s-gd", var.name)

  # Enable or Not
  cloudwatch_event_rule_is_enabled = var.is_enabled_notification.email_notify.enable

  input_transformer = local.input_transformer
  event_pattern = local.event_pattern

  cloudwatch_event_target_arn = module.sns_email.sns_topic_arn
  retry_policy = var.retry_policy

  tags = local.tags
}