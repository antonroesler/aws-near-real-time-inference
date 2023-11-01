# IAM; Keys; Security groups

module "security" {
  source            = "../modules/security"
  APP_NAME          = var.APP_NAME
  ENV               = var.ENV
  RESULT_BUCKET_ARN = module.storage.result_bucket_arn
  DYNAMO_DB         = module.stream.dynamo_db_table
  GLUE_DATABASE     = module.stream.glue_database
  GLUE_TABLE        = module.stream.glue_table
  GLUE_CATALOG      = module.stream.glue_catalog
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
}
