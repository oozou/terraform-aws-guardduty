module "gaurdduty_sandbox" {
  source = "../terraform-aws-guardduty"

  prefix      = "ms"
  name        = "pass"
  environment = "dev"

  finding_publishing_frequency = "ONE_HOUR"
  is_malware_protection_enabled = false
  is_kubernetes_protection_enabled = false

  # if the mail list not confirm, it won't be deleted by the terraform
  is_enabled_notification = {
    email_notify = {
      enable    = false
      mail_list     = ["email@domain.com"]
      is_enabled_low_severity_notification = true
      is_enabled_med_severity_notification  = true
      is_enabled_high_severity_notification = true
    }
  }

  custom_tags = { workspace = "ms-local-test"}
}