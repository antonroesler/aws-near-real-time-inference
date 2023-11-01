# Training bucket

resource "aws_s3_bucket" "training-bucket" {
  bucket = "${var.APP_NAME}-training-${var.ENV}"

  tags = {
    Name = "${var.APP_NAME}-training-${var.ENV}"
  }
}

resource "aws_s3_bucket_acl" "training-bucket-acl" {
  bucket = aws_s3_bucket.training-bucket.id
  acl    = "private"
}

# Results bucket

resource "aws_s3_bucket" "result-bucket" {
  bucket = "${var.APP_NAME}-results-${var.ENV}"

  tags = {
    Name = "${var.APP_NAME}-results-${var.ENV}"
  }
}

resource "aws_s3_bucket_acl" "result-bucket-acl" {
  bucket = aws_s3_bucket.result-bucket.id
  acl    = "private"
}
