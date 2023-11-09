# IAM; Keys; Security groups

module "security" {
  source                 = "../modules/security"
  APP_NAME               = var.APP_NAME
  AWS_REGION             = var.AWS_REGION
  ENV                    = var.ENV
  RESULT_BUCKET_ARN      = module.storage.result_bucket_arn
  DYNAMO_DB              = module.stream.dynamo_db_table_arn
  GLUE_DATABASE          = module.stream.glue_database
  GLUE_TABLE             = module.stream.glue_table
  LAMBDA_INFERENCE_ARN   = module.functions.lambda_inference_arn
  SFN_LOG_GROUP          = module.functions.sfn_log_group
  SFN_ARN                = module.functions.invoke_arn
  FIREHOSE_LOG_GROUP_ARN = module.stream.firehose_log_group_arn
  KINESIS_STREAM_ARN     = module.stream.kinesis_stream_arn
  TRANSFORMER_LAMBDA_ARN = module.stream.transformer_lamnda_arn
  MODEL_NAME_PREFIX      = var.MODEL_NAME_PREFIX
}


# S3 Buckets

module "storage" {
  source   = "../modules/storage"
  APP_NAME = var.APP_NAME
  ENV      = var.ENV
}

# Step Functions and Lambda Functions

module "functions" {
  source                = "../modules/functions"
  APP_NAME              = var.APP_NAME
  ENV                   = var.ENV
  STEP_FUNCTION_ROLE    = module.security.step_function_role
  RESULT_BUCKET_ARN     = module.storage.result_bucket_arn
  INFERENCE_LAMBDA_ROLE = module.security.inference_function_role
  DYNAMO_DB_TABLE_NAME  = module.stream.dynamo_db_table
}


module "stream" {
  source                  = "../modules/stream"
  APP_NAME                = var.APP_NAME
  ENV                     = var.ENV
  RESULT_BUCKET_ARN       = module.storage.result_bucket_arn
  RESULT_BUCKET_NAME      = module.storage.result_bucket_name
  TRANSFORMER_LAMBDA_ROLE = module.security.lambda_transformer_role
  FIREHOSE_ROLE           = module.security.firehose_role
  YEAR                    = "2023"
}

module "api" {
  source               = "../modules/api"
  APP_NAME             = var.APP_NAME
  ENV                  = var.ENV
  API_GW_ROLE          = module.security.api_gw_role
  STEP_FUNC_INVOKE_URI = module.functions.invoke_arn
  AWS_REGION           = var.AWS_REGION
}
