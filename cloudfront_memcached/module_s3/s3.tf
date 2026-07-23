resource "aws_s3_bucket" "this" {
  bucket = var.bucket_name

  tags = merge(
    {
      "Name" = format(
        "${var.prefix_name}-bucket"
      )
    },
    var.tags,
  )
}