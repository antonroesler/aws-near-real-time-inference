output "step_function_role" {
  value = aws_iam_role.sfn_role.arn
}

output "inference_function_role" {
  value = aws_iam_role.lambda_inference_role.arn
}

output "lambda_transformer_role" {
  value = aws_iam_role.lambda_transformer_role.arn
}
output "firehose_role" {
  value = aws_iam_role.firehose_role.arn
}


output "api_gw_role" {
  value = aws_iam_role.api_gw_role.arn
}

