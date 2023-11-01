# Kinesis Stream
resource "aws_kinesis_stream" "results-stream" {
  name        = "${var.APP_NAME}-results-stream-${var.ENV}"
  shard_count = 1
}

resource "aws_dynamodb_kinesis_streaming_destination" "resuslt-stream-destination" {
  stream_arn = aws_kinesis_stream.results-stream.arn
  table_name = aws_dynamodb_table.results-table.name
}
