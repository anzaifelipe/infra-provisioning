resource "aws_s3_bucket_policy" "public_bucket_policy" {
  count = var.enable_policy ? 1 : 0

  bucket = aws_s3_bucket.this.id
  policy = var.s3_bucket_policy 
}

resource "aws_s3_bucket_acl" "public_bucket_acl" {
  count = var.enable_public_bucket ? 1 : 0

  bucket = aws_s3_bucket.this.id
  acl    = "public-read"
}