output "cloudfront_public_medias" {
  value = aws_cloudfront_distribution.cloudfront_lb
}

output "policy_id" {
  value = coalescelist(aws_cloudfront_cache_policy.this.*.id, [null])[0]
}

output "heraders_id" {
  value = coalescelist(aws_cloudfront_response_headers_policy.this.*.id, [null])[0]
}