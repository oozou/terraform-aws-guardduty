# Terraform AWS GuardDuty Module

## Usage
See usage at `examples/simple`

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.00 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.00 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_eventbridge_mail"></a> [eventbridge\_mail](#module\_eventbridge\_mail) | oozou/eventbridge/aws | 1.0.1 |
| <a name="module_sns_email"></a> [sns\_email](#module\_sns\_email) | oozou/sns/aws | 1.0.1 |

## Resources

| Name | Type |
|------|------|
| [aws_guardduty_detector.guardduty](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/guardduty_detector) | resource |
| [aws_iam_policy_document.cwe](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_environment"></a> [environment](#input\_environment) | Environment Variable used as a prefix | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Name of the ECS cluster and s3 also redis to create | `string` | n/a | yes |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | The prefix name of customer to be displayed in AWS console and resource | `string` | n/a | yes |
| <a name="input_custom_tags"></a> [custom\_tags](#input\_custom\_tags) | Custom tags which can be passed on to the AWS resources. They should be key value pairs having distinct keys | `map(any)` | `{}` | no |
| <a name="input_finding_publishing_frequency"></a> [finding\_publishing\_frequency](#input\_finding\_publishing\_frequency) | Specifies the frequency of notifications sent for subsequent finding occurrences. <br>If the detector is a GuardDuty member account, the value is determined by the GuardDuty <br>primary account and cannot be modified, otherwise defaults to SIX\_HOURS. For standalone <br>and GuardDuty primary accounts, it must be configured in Terraform to enable drift detection. <br>Valid values for standalone and primary accounts: FIFTEEN\_MINUTES, ONE\_HOUR, SIX\_HOURS. <br>See AWS Documentation for more information., see:<br>https://docs.aws.amazon.com/guardduty/latest/ug/guardduty_findings_cloudwatch.html#guardduty_findings_cloudwatch_notification_frequency | `string` | `null` | no |
| <a name="input_is_enabled_notification"></a> [is\_enabled\_notification](#input\_is\_enabled\_notification) | n/a | <pre>object({<br>    email_notify = object({<br>      enable                                = bool<br>      mail_list                             = list(string)<br>      is_enabled_low_severity_notification  = bool<br>      is_enabled_med_severity_notification  = bool<br>      is_enabled_high_severity_notification = bool<br>    })<br>  })</pre> | <pre>{<br>  "email_notify": {<br>    "enable": false,<br>    "is_enabled_high_severity_notification": true,<br>    "is_enabled_low_severity_notification": false,<br>    "is_enabled_med_severity_notification": false,<br>    "mail_list": []<br>  }<br>}</pre> | no |
| <a name="input_is_kubernetes_protection_enabled"></a> [is\_kubernetes\_protection\_enabled](#input\_is\_kubernetes\_protection\_enabled) | n/a | `bool` | `true` | no |
| <a name="input_is_malware_protection_enabled"></a> [is\_malware\_protection\_enabled](#input\_is\_malware\_protection\_enabled) | n/a | `bool` | `false` | no |
| <a name="input_is_s3_protection_enabled"></a> [is\_s3\_protection\_enabled](#input\_is\_s3\_protection\_enabled) | Enables Amazon GuardDuty to monitor object-level API operations to identify potential security risks for data within your S3 buckets.<br>, see:<br>https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/guardduty_detector | `bool` | `false` | no |
| <a name="input_retry_policy"></a> [retry\_policy](#input\_retry\_policy) | n/a | <pre>object({<br>    maximum_retry_attempts       = number<br>    maximum_event_age_in_seconds = number<br>  })</pre> | <pre>{<br>  "maximum_event_age_in_seconds": 3600,<br>  "maximum_retry_attempts": 100<br>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_guardduty_detector"></a> [guardduty\_detector](#output\_guardduty\_detector) | GuardDuty detector |
<!-- END_TF_DOCS -->
