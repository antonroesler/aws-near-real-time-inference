
output "glue_database" {
  value = aws_glue_catalog_database.aws_glue_catalog_database.arn
}

output "glue_catalog" {
  value = aws_glue_catalog_database.aws_glue_catalog_database.catalog_id
}

output "glue_table" {
  value = aws_glue_catalog_table.aws_glue_catalog_table.arn
}

output "dynamo_db_table" {
  value = aws_dynamodb_table.results-table.name
}

output "dynamo_db_table_arn" {
  value = aws_dynamodb_table.results-table.arn
}
