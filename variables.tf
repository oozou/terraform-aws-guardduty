/* -------------------------------------------------------------------------- */
/*                                  Generics                                  */
/* -------------------------------------------------------------------------- */
variable "prefix" {
  description = "The prefix name of customer to be displayed in AWS console and resource"
  type        = string
}

variable "environment" {
  description = "Environment Variable used as a prefix"
  type        = string
}

variable "name" {
  description = "Name of the ECS cluster and s3 also redis to create"
  type        = string
}

variable "custom_tags" {
  description = "Custom tags which can be passed on to the AWS resources. They should be key value pairs having distinct keys"
  type        = map(any)
  default     = {}
}

/* -------------------------------------------------------------------------- */
/*                                  GuardDuty                                 */
/* -------------------------------------------------------------------------- */

variable "finding_publishing_frequency" {
  description = <<-DOC
  Specifies the frequency of notifications sent for subsequent finding occurrences. 
  If the detector is a GuardDuty member account, the value is determined by the GuardDuty 
  primary account and cannot be modified, otherwise defaults to SIX_HOURS. For standalone 
  and GuardDuty primary accounts, it must be configured in Terraform to enable drift detection. 
  Valid values for standalone and primary accounts: FIFTEEN_MINUTES, ONE_HOUR, SIX_HOURS. 
  See AWS Documentation for more information., see:
  https://docs.aws.amazon.com/guardduty/latest/ug/guardduty_findings_cloudwatch.html#guardduty_findings_cloudwatch_notification_frequency
  DOC
  type        = string
  default     = null
}

variable "is_s3_protection_enabled" {
  description = <<-DOC
  Enables Amazon GuardDuty to monitor object-level API operations to identify potential security risks for data within your S3 buckets.
  , see:
  https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/guardduty_detector
  DOC
  type        = bool
  default     = false
}

variable "is_malware_protection_enabled" {
  description = ""
  type        = bool
  default     = false
}

variable "is_kubernetes_protection_enabled" {
  description = ""
  type        = bool
  default     = true
}

/* -------------------------------------------------------------------------- */
/*                             EventBridge and SNS                            */
/* -------------------------------------------------------------------------- */

variable "retry_policy" {
  type = object({
    maximum_retry_attempts       = number
    maximum_event_age_in_seconds = number
  })
  default = {
    maximum_retry_attempts       = 100
    maximum_event_age_in_seconds = 3600
  }
}

variable "is_enabled_notification" {
  type = object({
    email_notify = object({
      enable                                = bool
      mail_list                             = list(string)
      is_enabled_low_severity_notification  = bool
      is_enabled_med_severity_notification  = bool
      is_enabled_high_severity_notification = bool
    })
  })
  default = {
    email_notify = {
      enable                                = false
      mail_list                             = []
      is_enabled_low_severity_notification  = false
      is_enabled_med_severity_notification  = false
      is_enabled_high_severity_notification = true
    }
  }

}
