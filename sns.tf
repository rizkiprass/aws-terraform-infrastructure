resource "aws_sns_topic" "cw-alarm" {
  name = format("%s-%s-alert", var.project, var.environment)
}