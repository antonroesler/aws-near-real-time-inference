
# Kinesis Firehose
resource "aws_kinesis_firehose_delivery_stream" "result-delivery-stream" {
  name        = "${var.APP_NAME}-results-stream-${var.ENV}"
  destination = "extended_s3"

  extended_s3_configuration {
    role_arn   = var.FIREHOSE_ROLE
    bucket_arn = var.RESULT_BUCKET_ARN
    prefix     = "results"

    processing_configuration {
      enabled = "true"

      processors {
        type = "Lambda"

        parameters {
          parameter_name  = "LambdaArn"
          parameter_value = "${aws_lambda_function.result-stream-transformer.arn}:$LATEST"
        }
      }
    }



    data_format_conversion_configuration {
      input_format_configuration {
        deserializer {
          hive_json_ser_de {}
        }
      }

      output_format_configuration {
        serializer {
          parquet_ser_de {}
        }
      }

      schema_configuration {
        database_name = aws_glue_catalog_table.aws_glue_catalog_table.name
        role_arn      = var.FIREHOSE_ROLE
        table_name    = aws_glue_catalog_table.aws_glue_catalog_table.name
      }
    }
    buffering_size     = 64 # 64 mb, minimum size
    buffering_interval = 60 # 1 min


  }


}

resource "aws_glue_catalog_database" "aws_glue_catalog_database" {
  name = "${var.APP_NAME}-stream-database-${var.ENV}"
}

resource "aws_glue_catalog_table" "aws_glue_catalog_table" {
  name          = "${var.APP_NAME}-stream-table-${var.ENV}"
  database_name = aws_glue_catalog_database.aws_glue_catalog_database.name

  table_type = "EXTERNAL_TABLE"

  parameters = {
    EXTERNAL              = "TRUE"
    "parquet.compression" = "NONE"
    "classification"      = "parquet"
  }

  storage_descriptor {
    location      = "s3://${var.RESULT_BUCKET_NAME}/event-streams/results"
    input_format  = "org.apache.hadoop.hive.ql.io.parquet.MapredParquetInputFormat"
    output_format = "org.apache.hadoop.hive.ql.io.parquet.MapredParquetOutputFormat"

    ser_de_info {
      name                  = "my-stream"
      serialization_library = "org.apache.hadoop.hive.ql.io.parquet.serde.ParquetHiveSerDe"

      parameters = {
        "serialization.format" = 1
      }
    }

    columns {
      name = "timestamp"
      type = "bigint"
    }
    columns {
      name = "sensor"
      type = "string"

    }
    columns {
      name = "failure-prediction"
      type = "int"
    }
    columns {
      name = "probability"
      type = "double"

    }
  }
}
