output "result_bucket_name" {
  value = aws_s3_bucket.result-bucket.bucket
}

output "result_bucket_arn" {
  value = aws_s3_bucket.result-bucket.arn
}
