resource "aws_sns_topic" "cw-alarm" {
  name = format("%s-%s-%s-alert", var.customer, var.project, var.environment)
}