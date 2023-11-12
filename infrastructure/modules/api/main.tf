# API Gateway

resource "aws_api_gateway_rest_api" "api" {
  name = "${var.APP_NAME}-api-${var.ENV}"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_resource" "pipeline-route" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = "pipeline"
}

resource "aws_api_gateway_method" "pipeline-post" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.pipeline-route.id
  http_method   = "POST"
  authorization = "NONE"
}


resource "aws_api_gateway_integration" "api-workflow-integration" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.pipeline-route.id
  http_method             = aws_api_gateway_method.pipeline-post.http_method
  integration_http_method = "POST"
  type                    = "AWS"
  timeout_milliseconds    = 3000
  uri                     = "arn:aws:apigateway:${var.AWS_REGION}:states:action/StartExecution"
  credentials             = var.API_GW_ROLE

  request_templates = {
    "application/json" = <<EOF
{
    "input": "$util.escapeJavaScript($input.json('$'))",
    "stateMachineArn": "${var.STEP_FUNC_INVOKE_URI}"
}
EOF
  }

}

resource "aws_api_gateway_stage" "stage" {
  deployment_id = aws_api_gateway_deployment.api.id
  rest_api_id   = aws_api_gateway_rest_api.api.id
  stage_name    = var.ENV
}


resource "aws_api_gateway_method_response" "response_200" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.pipeline-route.id
  http_method = aws_api_gateway_method.pipeline-post.http_method
  status_code = "200"
}

resource "aws_api_gateway_integration_response" "workflow_response" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.pipeline-route.id
  http_method = aws_api_gateway_method.pipeline-post.http_method
  status_code = aws_api_gateway_method_response.response_200.status_code

  # Transforms the backend JSON response to XML
  response_templates = {
    "application/json" = <<EOF
  {
    "status" : "accepted"
  }
EOF
  }
}


resource "aws_api_gateway_deployment" "api" {
  rest_api_id = aws_api_gateway_rest_api.api.id

  # lifecycle {
  #   create_before_destroy = true
  # }
}
