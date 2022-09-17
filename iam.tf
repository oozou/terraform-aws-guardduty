data "aws_iam_policy_document" "cwe" {
  statement {
    sid = "Allow CWE to use the key"

    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }

    actions = [
      "kms:Decrypt",
      "kms:GenerateDataKey"
    ]

    resources = [
      "*"
    ]

  }
}