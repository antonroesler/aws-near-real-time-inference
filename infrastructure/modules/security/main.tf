# Inference Role
data "aws_iam_policy_document" "lambda_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}


resource "aws_iam_role" "lambda_inference_role" {
  name               = "${var.APP_NAME}-lambda-inference-${var.ENV}"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json
}

data "aws_iam_policy_document" "allow_inference" {
  statement {
    effect    = "Allow"
    resources = ["*"] # TODO, allow only specific endpoints to be invoked
    actions   = ["sagemaker:InvokeEndpoint"]
  }
  statement {
    effect    = "Allow"
    resources = ["*"]
    actions   = ["logs:CreateLogGroup", "logs:CreateLogStream", "logs:PutLogEvents"]
  }
}

resource "aws_iam_policy" "allow_lambda_inference" {
  name   = "${var.APP_NAME}-inference-policy-${var.ENV}"
  policy = data.aws_iam_policy_document.allow_inference.json
}

resource "aws_iam_role_policy_attachment" "lambda_attach_inference" {
  role       = aws_iam_role.lambda_inference_role.name
  policy_arn = aws_iam_policy.allow_lambda_inference.arn
}


# Step Function Role
resource "aws_iam_policy" "put_dynamo" {
  name   = "${var.APP_NAME}-dynamodb-policy-${var.ENV}"
  policy = data.aws_iam_policy_document.allow_put_dynamo.json
}

data "aws_iam_policy_document" "sfn_assume_role" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["states.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "allow_put_dynamo" {
  statement {
    effect    = "Allow"
    resources = ["${var.DYNAMO_DB}"]
    actions   = ["dynamodb:Put*"]
  }
  statement {
    effect    = "Allow"
    resources = ["${var.LAMBDA_INFERENCE_ARN}"]
    actions   = ["lambda:InvokeFunction"]
  }
  statement {
    effect    = "Allow"
    resources = ["${var.SFN_LOG_GROUP}"]
    actions   = ["logs:*"]
  }
}

resource "aws_iam_role" "sfn_role" {
  name               = "${var.APP_NAME}-step-function-role-${var.ENV}"
  assume_role_policy = data.aws_iam_policy_document.sfn_assume_role.json
}

resource "aws_iam_role_policy_attachment" "sfn_attach_dynamo_put" {
  role       = aws_iam_role.sfn_role.name
  policy_arn = aws_iam_policy.put_dynamo.arn
}


# Transformer Role
resource "aws_iam_role" "lambda_transformer_role" {
  name               = "${var.APP_NAME}-lambda-transformer-${var.ENV}"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json
}

data "aws_iam_policy_document" "allow_transform" {
  statement {
    effect    = "Allow"
    resources = ["*"] # TODO, allow only specific endpoints to be invoked
    actions   = ["logs:CreateLogGroup", "logs:CreateLogStream", "logs:PutLogEvents"]
  }
}

resource "aws_iam_policy" "allow_lambda_transform" {
  name   = "${var.APP_NAME}-transform-policy-${var.ENV}"
  policy = data.aws_iam_policy_document.allow_transform.json
}

resource "aws_iam_role_policy_attachment" "lambda_attach_transform" {
  role       = aws_iam_role.lambda_transformer_role.name
  policy_arn = aws_iam_policy.allow_lambda_transform.arn
}


# Firehose Role

data "aws_iam_policy_document" "firehose_assume_policy" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["firehose.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "firehose_role" {
  name               = "${var.APP_NAME}-firehose-${var.ENV}"
  assume_role_policy = data.aws_iam_policy_document.firehose_assume_policy.json
}

#########
data "aws_iam_policy_document" "firehose_iam_policy" {
  statement {
    sid    = ""
    effect = "Allow"

    resources = [
      var.GLUE_TABLE,
      var.GLUE_DATABASE,
    ]

    actions = [
      "glue:GetTable",
      "glue:GetTableVersion",
      "glue:GetTableVersions",
    ]
  }

  statement {
    sid       = ""
    effect    = "Allow"
    resources = ["arn:aws:kafka:${var.AWS_REGION}::cluster/%FIREHOSE_POLICY_TEMPLATE_PLACEHOLDER%/%FIREHOSE_POLICY_TEMPLATE_PLACEHOLDER%"]

    actions = [
      "kafka:GetBootstrapBrokers",
      "kafka:DescribeCluster",
      "kafka:DescribeClusterV2",
      "kafka-cluster:Connect",
    ]
  }

  statement {
    sid       = ""
    effect    = "Allow"
    resources = ["arn:aws:kafka:${var.AWS_REGION}::topic/%FIREHOSE_POLICY_TEMPLATE_PLACEHOLDER%/%FIREHOSE_POLICY_TEMPLATE_PLACEHOLDER%/%FIREHOSE_POLICY_TEMPLATE_PLACEHOLDER%"]

    actions = [
      "kafka-cluster:DescribeTopic",
      "kafka-cluster:DescribeTopicDynamicConfiguration",
      "kafka-cluster:ReadData",
    ]
  }

  statement {
    sid       = ""
    effect    = "Allow"
    resources = ["arn:aws:kafka:${var.AWS_REGION}::group/%FIREHOSE_POLICY_TEMPLATE_PLACEHOLDER%/%FIREHOSE_POLICY_TEMPLATE_PLACEHOLDER%/*"]
    actions   = ["kafka-cluster:DescribeGroup"]
  }

  statement {
    sid    = ""
    effect = "Allow"

    resources = [
      var.RESULT_BUCKET_ARN,
      "${var.RESULT_BUCKET_ARN}/*",
    ]

    actions = [
      "s3:AbortMultipartUpload",
      "s3:GetBucketLocation",
      "s3:GetObject",
      "s3:ListBucket",
      "s3:ListBucketMultipartUploads",
      "s3:PutObject",
    ]
  }

  statement {
    sid       = ""
    effect    = "Allow"
    resources = ["${var.TRANSFORMER_LAMBDA_ARN}:$LATEST"]

    actions = [
      "lambda:InvokeFunction",
      "lambda:GetFunctionConfiguration",
    ]
  }

  statement {
    sid       = ""
    effect    = "Allow"
    resources = ["arn:aws:kms:${var.AWS_REGION}::key/%FIREHOSE_POLICY_TEMPLATE_PLACEHOLDER%"]

    actions = [
      "kms:GenerateDataKey",
      "kms:Decrypt",
    ]

    condition {
      test     = "StringEquals"
      variable = "kms:ViaService"
      values   = ["s3.${var.AWS_REGION}.amazonaws.com"]
    }

    condition {
      test     = "StringLike"
      variable = "kms:EncryptionContext:aws:s3:arn"

      values = [
        "arn:aws:s3:::%FIREHOSE_POLICY_TEMPLATE_PLACEHOLDER%/*",
        "arn:aws:s3:::%FIREHOSE_POLICY_TEMPLATE_PLACEHOLDER%",
      ]
    }
  }

  statement {
    sid    = ""
    effect = "Allow"

    resources = [
      "${var.FIREHOSE_LOG_GROUP_ARN}:*",
      # "arn:aws:logs:::log-group:%FIREHOSE_POLICY_TEMPLATE_PLACEHOLDER%:log-stream:*",
    ]

    actions = ["logs:PutLogEvents"]
  }

  statement {
    sid       = ""
    effect    = "Allow"
    resources = [var.KINESIS_STREAM_ARN]

    actions = [
      "kinesis:DescribeStream",
      "kinesis:GetShardIterator",
      "kinesis:GetRecords",
      "kinesis:ListShards",
    ]
  }

  statement {
    sid       = ""
    effect    = "Allow"
    resources = ["arn:aws:kms:${var.AWS_REGION}::key/%FIREHOSE_POLICY_TEMPLATE_PLACEHOLDER%"]
    actions   = ["kms:Decrypt"]

    condition {
      test     = "StringEquals"
      variable = "kms:ViaService"
      values   = ["kinesis.${var.AWS_REGION}.amazonaws.com"]
    }

    condition {
      test     = "StringLike"
      variable = "kms:EncryptionContext:aws:kinesis:arn"
      values   = [var.KINESIS_STREAM_ARN]
    }
  }
}


#########

resource "aws_iam_policy" "firehose_iam" {
  name   = "${var.APP_NAME}-firehose-policy-${var.ENV}"
  policy = data.aws_iam_policy_document.firehose_iam_policy.json
}

resource "aws_iam_role_policy_attachment" "firehose_attach" {
  role       = aws_iam_role.firehose_role.name
  policy_arn = aws_iam_policy.firehose_iam.arn
}


# API Gateway ROle

data "aws_iam_policy_document" "api_gw_assume_policy" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["apigateway.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "api_gw_role" {
  name               = "${var.APP_NAME}-api-gw-${var.ENV}"
  assume_role_policy = data.aws_iam_policy_document.api_gw_assume_policy.json
}


data "aws_iam_policy_document" "api_gw_iam_policy" {
  statement {
    effect    = "Allow"
    resources = [var.SFN_ARN]
    actions   = ["states:StartExecution"]
  }
}

resource "aws_iam_policy" "api_gw_iam" {
  name   = "${var.APP_NAME}-api-gw-policy-${var.ENV}"
  policy = data.aws_iam_policy_document.api_gw_iam_policy.json
}

resource "aws_iam_role_policy_attachment" "api_gw_attach_sfn" {
  role       = aws_iam_role.api_gw_role.name
  policy_arn = aws_iam_policy.api_gw_iam.arn
}

resource "aws_iam_role_policy_attachment" "api_gw_attach_cloud_watch" {
  role       = aws_iam_role.api_gw_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonAPIGatewayPushToCloudWatchLogs"
}
