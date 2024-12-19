// Creation of SNS Resource
resource "aws_sns_topic" "sns-topic" {
  name                        = var.name
  fifo_topic                  = var.fifo
  content_based_deduplication = var.deduplication
  tags = {
    "environment" = "Dev"
  }
}

// SNS Variables
variable "name" {
  type    = string
  default = "GuardDuty-Findings-Topic"
}

variable "fifo" {
  type    = bool
  default = false
}

variable "deduplication" {
  type    = bool
  default = false
}

variable "target_id" {
  type    = string
  default = "SendToSNS"
}

#// Creation of email subscription
#resource "aws_sns_topic_subscription" "sns_topic_subscription-email" {
#  topic_arn = aws_sns_topic.sns-topic.arn
#  protocol  = "email"
#  endpoint  = "rizki.prasetya@icscompute.com"
#}

// Creation of CloudWatch event rule
resource "aws_cloudwatch_event_rule" "gd-cw-alert-rule" {
  name        = var.event_name
  description = var.description
  is_enabled  = var.enabled

  event_pattern = <<EOF
{
  "source": ["aws.guardduty"],
  "detail-type": ["GuardDuty Finding"],
  "detail": {
    "severity": [4, 4.1, 4.2, 4.3, 4.4, 4.5, 4.6, 4.7, 4.8, 4.9, 5, 5.1, 5.2, 5.3, 5.4, 5.5, 5.6, 5.7, 5.8, 5.9, 6, 6.0, 6.1, 6.2, 6.3, 6.4, 6.5, 6.6, 6.7, 6.8, 6.9, 7, 7.0, 7.1, 7.2, 7.3, 7.4, 7.5, 7.6, 7.7, 7.8, 7.9, 8, 8.0, 8.1, 8.2, 8.3, 8.4, 8.5, 8.6, 8.7, 8.8, 8.9]
  }
}
EOF
}

// Creation of CloudWatch event target to SNS
resource "aws_cloudwatch_event_target" "sns-guardduty" {
  rule      = aws_cloudwatch_event_rule.gd-cw-alert-rule.name
  arn       = aws_sns_topic.sns-topic.arn
  target_id = var.target_id

  input_transformer {
    input_paths = {
      "severity"            = "$.detail.severity",
      "Account_ID"          = "$.detail.accountId",
      "Finding_ID"          = "$.detail.id",
      "Finding_Type"        = "$.detail.type",
      "region"              = "$.region",
      "Finding_description" = "$.detail.description"
    }

    input_template = <<TEMPLATE
"AWS <Account_ID> has a severity <severity> GuardDuty finding type <Finding_Type> in the <region> region."
"Finding Description:"
"<Finding_description>. "
"For more details open the GuardDuty console at https://console.aws.amazon.com/guardduty/home?region=<region>#/findings?search=id%3D<Finding_ID>"
TEMPLATE
  }

  depends_on = [aws_cloudwatch_event_rule.gd-cw-alert-rule]
}

// CloudWatch Variables
variable "event_name" {
  type    = string
  default = "Guardduty-event-rule"
}

variable "description" {
  type    = string
  default = "Event Rule to capture Guard duty findings Medium to Critical finding"
}

variable "enabled" {
  type    = bool
  default = true
}
