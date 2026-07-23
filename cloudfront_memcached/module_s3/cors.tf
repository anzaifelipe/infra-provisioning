resource "aws_s3_bucket_cors_configuration" "this" {
  count = var.cors ? 1 : 0

  bucket = aws_s3_bucket.this.bucket

  cors_rule {
        allowed_headers = ["*"]
        allowed_methods = ["GET" , "HEAD"]
        allowed_origins = ["*"]
        expose_headers = []
        max_age_seconds = 86400
    } 
}