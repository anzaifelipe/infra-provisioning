output "arn" {
  value       = aws_s3_bucket.this.arn
  description = "ARN of the bucket. Will be of format arn:aws:s3:::bucketname"
}

output "id" {
  value       = aws_s3_bucket.this.id
  description = "Name of the bucket"
}

output "bucket_domain_name" {
  value       = aws_s3_bucket.this.bucket_domain_name
  description = "Bucket domain name. Will be of format"
}

output "bucket_regional_domain_name" {
  value       = aws_s3_bucket.this.bucket_regional_domain_name
  description = "Bucket region domain name. Will be of format"
}

output "region" {
  value       = aws_s3_bucket.this.region
  description = "AWS region this bucket resides in."
}