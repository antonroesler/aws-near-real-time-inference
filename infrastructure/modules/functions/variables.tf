variable "APP_NAME" {
  type = string
}

variable "ENV" {
  type = string
}

variable "RESULT_BUCKET_ARN" {
  type = string
}

variable "INFERENCE_LAMBDA_ROLE" {
  type = string
}

variable "STEP_FUNCTION_ROLE" {
  type = string
}

variable "DYNAMO_DB_TABLE_NAME" {
  type = string
}
