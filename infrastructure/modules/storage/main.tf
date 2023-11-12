# Training bucket

resource "aws_s3_bucket" "training-bucket" {
  bucket = "${var.APP_NAME}-training-${var.ENV}"

  tags = {
    Name = "${var.APP_NAME}-training-${var.ENV}"
  }
}

# Results bucket

resource "aws_s3_bucket" "result-bucket" {
  bucket = "${var.APP_NAME}-results-${var.ENV}"

  tags = {
    Name = "${var.APP_NAME}-results-${var.ENV}"
  }
}
