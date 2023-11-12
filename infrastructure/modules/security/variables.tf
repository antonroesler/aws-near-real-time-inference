variable "APP_NAME" {
  type = string
}
variable "ACCOUNT_ID" {
  type = string
}

variable "ENV" {
  type = string
}

variable "AWS_REGION" {
  type = string
}

variable "RESULT_BUCKET_ARN" {
  type = string
}

variable "DYNAMO_DB" {
  type = string
}

variable "GLUE_DATABASE" {
  type = string
}

variable "GLUE_TABLE" {
  type = string
}

variable "LAMBDA_INFERENCE_ARN" {
  type = string
}

variable "SFN_LOG_GROUP" {
  type = string
}

variable "SFN_ARN" {
  type        = string
  description = "ARN of the stepfunction state machine"
}

variable "FIREHOSE_LOG_GROUP_ARN" {
  type = string
}

variable "KINESIS_STREAM_ARN" {
  type = string
}

variable "TRANSFORMER_LAMBDA_ARN" {
  type = string
}

variable "MODEL_NAME_PREFIX" {
  type = string
}
