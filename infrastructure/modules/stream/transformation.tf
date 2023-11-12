data "archive_file" "lambda-transformer" {
  type        = "zip"
  source_file = "${path.module}/function/main.py"
  output_path = "${path.module}/function/lambda_transfomer.zip"
}

resource "aws_lambda_function" "result-stream-transformer" {
  filename      = data.archive_file.lambda-transformer.output_path
  function_name = "${var.APP_NAME}-firehose-transformer-${var.ENV}"
  role          = var.TRANSFORMER_LAMBDA_ROLE
  handler       = "main.lambda_handler"
  runtime       = "python3.10"
}
