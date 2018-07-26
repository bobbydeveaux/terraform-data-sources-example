provider "aws" {
  region = "us-west-1"
}

data "aws_iam_role" "selected" {
  name = "lambda-role"
}

resource "aws_lambda_function" "test_lambda" {
  filename         = "lambda_function_payload.zip"
  function_name    = "lambda_function_name"
  role             = "${data.aws_iam_role.selected.arn}"
  handler          = "main"
  source_code_hash = "${base64sha256(file("lambda_function_payload.zip"))}"
  runtime          = "go1.x"

  environment {
    variables = {
      foo = "bar"
    }
  }
}