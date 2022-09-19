locals {
  tags = merge(
    {
      "Environment" = var.environment,
      "Terraform"   = "true"
    },
    var.custom_tags
  )
}

/* -------------------------------------------------------------------------- */
/*                             Notification Logic                             */
/* -------------------------------------------------------------------------- */
locals {
  is_enabled_low_severity_email_notification  = var.is_enabled_notification.email_notify.is_enabled_low_severity_notification
  is_enabled_med_severity_email_notification  = var.is_enabled_notification.email_notify.is_enabled_med_severity_notification
  is_enabled_high_severity_email_notification = var.is_enabled_notification.email_notify.is_enabled_high_severity_notification
}

/* -------------------------------------------------------------------------- */
/*                               Event Serverity                              */
/* -------------------------------------------------------------------------- */
locals {
  # See the severity ref at: https://docs.aws.amazon.com/guardduty/latest/ug/guardduty_findings.html

  low_severity = local.is_enabled_low_severity_email_notification ? [
    1, 1.0, 1.1, 1.2, 1.3, 1.4, 1.5, 1.6, 1.7, 1.8, 1.9,
    2, 2.0, 2.1, 2.2, 2.3, 2.4, 2.5, 2.6, 2.7, 2.8, 2.9,
    3, 3.0, 3.1, 3.2, 3.3, 3.4, 3.5, 3.6, 3.7, 3.8, 3.9
  ] : []
  med_severity = local.is_enabled_med_severity_email_notification ? [
    4, 4.0, 4.1, 4.2, 4.3, 4.4, 4.5, 4.6, 4.7, 4.8, 4.9,
    5, 5.0, 5.1, 5.2, 5.3, 5.4, 5.5, 5.6, 5.7, 5.8, 5.9,
    6, 6.0, 6.1, 6.2, 6.3, 6.4, 6.5, 6.6, 6.7, 6.8, 6.9
  ] : []
  high_severity = local.is_enabled_high_severity_email_notification ? [
    7, 7.0, 7.1, 7.2, 7.3, 7.4, 7.5, 7.6, 7.7, 7.8, 7.9,
    8, 8.0, 8.1, 8.2, 8.3, 8.4, 8.5, 8.6, 8.7, 8.8, 8.9
  ] : []
  event_pattern = jsonencode(
    {
      "source" : [
        "aws.guardduty"
      ],
      "detail" : {
        "severity" : concat(local.low_severity, local.med_severity, local.high_severity)
      }

    }
  )
}

/* -------------------------------------------------------------------------- */
/*                              Input Transformer                             */
/* -------------------------------------------------------------------------- */
locals {
  input_transformer = {
    input_paths = {
      severity     = "$.detail.severity",
      Finding_ID   = "$.detail.id",
      Finding_Type = "$.detail.type",
      count        = "$.detail.service.count",
      region       = "$.region"
    }
    input_template = "\"You have a severity <severity> GuardDuty finding type <Finding_Type>. The total occurrence is <count>. For more details open the GuardDuty console at https://console.aws.amazon.com/guardduty/home?region=<region>#/findings?search=id%3D<Finding_ID>\""
  }
}

/* -------------------------------------------------------------------------- */
/*                               Raise Conidtion                              */
/* -------------------------------------------------------------------------- */
locals {
  raise_mail_is_empty_with_enable_mail_notification = var.is_enabled_notification.email_notify.enable && length(var.is_enabled_notification.email_notify.mail_list) == 0 ? file("Mail list is empty, Please input at lease 1 address.") : "pass"
}
