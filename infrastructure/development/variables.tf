variable "AWS_REGION" {
  default     = "eu-central-1"
  description = "Germany (Frankfurt) Region"
}

variable "APP_NAME" {
  default = "signal-detector"
}

variable "ENV" {
  default = "development"
}

variable "BACKEND_BUCKET" {
  default = "tf-signal-detection-backend"
}

variable "BACKEND_DYNAMODB" {
  default = "tf-signal-detection-lock-db"
}

variable "MODEL_NAME_PREFIX" {
  default = "serverless"
}

variable "YEAR" {
  default = "2023"
}
