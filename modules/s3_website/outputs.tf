output "website_url" {
  description = "Website URL (HTTPS)"
  value       = aws_cloudfront_distribution.distribution.domain_name
}

output "s3_url" {
  description = "S3 hosting URL (HTTP)"
  value       = aws_s3_bucket_website_configuration.hosting.website_endpoint
}

output "invalidation_command" {
  description = "Command to invalidate CloudFront cache"
  value       = "aws cloudfront create-invalidation --distribution-id ${aws_cloudfront_distribution.distribution.id} --paths '/*'"
}