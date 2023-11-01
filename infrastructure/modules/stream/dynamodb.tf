# DynamoDB
resource "aws_dynamodb_table" "results-table" {
  name         = "${var.APP_NAME}-results-stream-${var.ENV}"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "timestamp"
  range_key    = "sensor"

  attribute {
    name = "timestamp"
    type = "N"
  }

  attribute {
    name = "sensor"
    type = "S"
  }


  ttl {
    attribute_name = "TimeToExist"
    enabled        = false
  }

  tags = {
    Name        = "${var.APP_NAME}-results-${var.ENV}"
    Environment = var.ENV
  }
}
