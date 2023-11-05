
output "glue_database" {
  value = aws_glue_catalog_database.aws_glue_catalog_database.arn
}

output "glue_table" {
  value = aws_glue_catalog_table.aws_glue_catalog_table.arn
}

output "dynamo_db_table" {
  value = aws_dynamodb_table.results_table.name
}

output "dynamo_db_table_arn" {
  value = aws_dynamodb_table.results_table.arn
}

output "firehose_log_group_arn" {
  value = aws_cloudwatch_log_group.firehose_logs.arn
}

output "kinesis_stream_arn" {
  value = aws_kinesis_stream.results-stream.arn
}

output "transformer_lamnda_arn" {
  value = aws_lambda_function.result-stream-transformer.arn
}
