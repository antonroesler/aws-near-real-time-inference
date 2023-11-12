# DynamoDB
resource "aws_dynamodb_table" "results_table" {
  name         = "${var.APP_NAME}-results-stream-${var.ENV}"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "timestamp"
  range_key    = "sensor"

  stream_enabled   = true
  stream_view_type = "NEW_AND_OLD_IMAGES"

  attribute {
    name = "timestamp"
    type = "N"
  }

  attribute {
    name = "sensor"
    type = "S"
  }

  tags = {
    Name        = "${var.APP_NAME}-results-${var.ENV}"
    Environment = var.ENV
  }
}
