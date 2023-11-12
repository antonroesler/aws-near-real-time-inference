output "invoke_arn" {
  value = aws_sfn_state_machine.sfn_state_machine.arn
}

output "lambda_inference_arn" {
  value = aws_lambda_function.result-stream-inference.arn
}


output "sfn_log_group" {
  value = aws_cloudwatch_log_group.sfn-logs.arn
}
