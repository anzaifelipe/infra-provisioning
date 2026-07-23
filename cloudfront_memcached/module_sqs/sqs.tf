resource "aws_sqs_queue" "this" {

  content_based_deduplication = var.content_based_deduplication
  deduplication_scope         = var.deduplication_scope
  delay_seconds               = var.delay_seconds
  fifo_queue                        = var.fifo_queue
  fifo_throughput_limit             = var.fifo_throughput_limit
  max_message_size                  = var.max_message_size
  message_retention_seconds         = var.message_retention_seconds
  name                              = var.name
  receive_wait_time_seconds         = var.receive_wait_time_seconds
  visibility_timeout_seconds        = var.visibility_timeout_seconds
  policy                            = var.policy

  tags = merge(
    {
      "Name" = format(
        "${var.name}"
      )
    },
    var.tags,
  )
}