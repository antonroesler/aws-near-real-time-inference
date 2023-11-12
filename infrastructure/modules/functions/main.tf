# Lambda Inference Function
data "archive_file" "lambda-inference" {
  type        = "zip"
  source_file = "${path.module}/function/main.py"
  output_path = "${path.module}/function/lambda_inference.zip"
}

resource "aws_lambda_function" "result-stream-inference" {
  filename      = data.archive_file.lambda-inference.output_path
  function_name = "${var.APP_NAME}-firehose-inference-${var.ENV}"
  role          = var.INFERENCE_LAMBDA_ROLE
  handler       = "main.lambda_handler"
  runtime       = "python3.11"
  timeout       = 50
}

# Step Functions State Machine

resource "aws_sfn_state_machine" "sfn_state_machine" {
  name     = "${var.APP_NAME}-state-machine-${var.ENV}"
  role_arn = var.STEP_FUNCTION_ROLE
  type     = "STANDARD"

  definition = <<EOF
{
  "Comment": "A description of my state machine",
  "StartAt": "Inference",
  "States": {
    "Inference": {
      "Type": "Task",
      "Resource": "arn:aws:states:::lambda:invoke",
      "OutputPath": "$.Payload",
      "Parameters": {
        "Payload.$": "$",
        "FunctionName": "${aws_lambda_function.result-stream-inference.arn}"
      },
      "Retry": [
        {
          "ErrorEquals": [
            "Lambda.ServiceException",
            "Lambda.AWSLambdaException",
            "Lambda.SdkClientException",
            "Lambda.TooManyRequestsException"
          ],
          "IntervalSeconds": 1,
          "MaxAttempts": 3,
          "BackoffRate": 2
        }
      ],
      "Next": "DynamoDB PutItem"
    },
    "DynamoDB PutItem": {
      "Type": "Task",
      "Resource": "arn:aws:states:::dynamodb:putItem",
      "Parameters": {
        "TableName": "${var.DYNAMO_DB_TABLE_NAME}",
        "Item": {
          "timestamp": {
            "N.$": "$.body.timestamp"
          },
          "sensor": {
            "S.$": "$.body.sensor"
          },
          "failure-prediction": {
            "N.$": "$.body.prediction"
          },
          "probability": {
            "N.$": "$.body.probability"
          }
        }
      },
      "End": true
    }
  }
}
EOF
}

resource "aws_cloudwatch_log_group" "sfn-logs" {
  name = "${var.APP_NAME}-state-machine-logs-${var.ENV}"

  tags = {
    Environment = var.ENV
    Application = var.APP_NAME
  }
}
