# API Gateway

resource "aws_api_gateway_rest_api" "api" {
  name = "${var.APP_NAME}-api-${var.ENV}"
}

resource "aws_api_gateway_resource" "pipeline-route" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = "/pipeline"
}

resource "aws_api_gateway_method" "pipeline-post" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.pipeline-route.id
  http_method   = "POST"
  authorization = "NONE"
}


resource "aws_api_gateway_integration" "api-workflow-integration" {
  rest_api_id          = aws_api_gateway_rest_api.api.id
  resource_id          = aws_api_gateway_resource.pipeline-route.id
  http_method          = aws_api_gateway_method.pipeline-post.http_method
  type                 = "AWS"
  timeout_milliseconds = 3000
  uri                  = var.STEP_FUNC_INVOKE_URI
  credentials          = var.API_GW_ROLE

}
