resource "aws_sns_topic" "staff_notification_topic" {
  name = var.prefix_name
}

resource "aws_sns_topic_subscription" "staff_notification_subscription" {
  topic_arn = aws_sns_topic.staff_notification_topic.arn
  protocol  = "email"
  endpoint  = var.staff_notification_email
}