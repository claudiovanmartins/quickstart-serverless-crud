resource "aws_iam_policy" "customPolicy"{
    name = "LambdaToDynamoDB"

    policy = jsonencode(
        {
        "Version": "2012-10-17",
        "Statement": [
            {
                "Sid": "VisualEditor1",
                "Effect": "Allow",
                "Action": [
                    "dynamodb:BatchGetItem",
                    "dynamodb:BatchWriteItem",
                    "dynamodb:PutItem",
                    "dynamodb:GetItem",
                    "dynamodb:Scan",
                    "dynamodb:Query",
                    "dynamodb:UpdateItem"
                ],
                 "Resource": "${aws_dynamodb_table.dynamodbtable.arn}"
            },
            {
                "Sid": "VisualEditor2",
                "Effect": "Allow",
                "Action": [
                    "logs:CreateLogStream",
                    "logs:PutLogEvents",
                    "logs:CreateLogGroup"
                ],
                "Resource": "*"
            }
        ]
    })
}

data "aws_iam_policy_document" "policy" {
  statement {
    sid    = ""
    effect = "Allow"

    principals {
      identifiers = ["lambda.amazonaws.com"]
      type        = "Service"
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "lambda-role" {
  name               = "lambda-role"
  assume_role_policy = data.aws_iam_policy_document.policy.json
}

resource "aws_iam_role_policy_attachment" "policyBind" {
    role = aws_iam_role.lambda-role.name
    policy_arn = aws_iam_policy.customPolicy.arn
}

data "archive_file" "put_file_zip" {
  type        = "zip"
  source_file = "${path.module}./application/${var.put_script_name}.py"
  output_path = "${path.module}./application/${var.put_script_name}.zip"
}

data "archive_file" "scan_file_zip" {
  type        = "zip"
  source_file = "${path.module}./application/${var.scan_script_name}.py"
  output_path = "${path.module}./application/${var.scan_script_name}.zip"
}

resource "aws_lambda_function" "put_movie_lambda" {
  
  function_name = var.lambda_put_script_name
  description = var.lambda_put_script_description

  filename = data.archive_file.put_file_zip.output_path
  source_code_hash = data.archive_file.put_file_zip.output_base64sha256

  role          = aws_iam_role.lambda-role.arn
  handler       = "${var.put_script_name}.lambda_handler"
  runtime       = var.lambda_runtime

  tags = {
        Name = var.lambda_put_script_name
        Projeto = "QuickStart",
        Environment = "desenvolvimento"
   }

  depends_on = [
    aws_dynamodb_table.dynamodbtable,
  ]

}

resource "aws_lambda_function" "scan_movie_lambda" {
  
  function_name = var.lambda_scan_script_name
  description = var.lambda_scan_script_description

  filename = data.archive_file.scan_file_zip.output_path
  source_code_hash = data.archive_file.scan_file_zip.output_base64sha256

  role          = aws_iam_role.lambda-role.arn
  handler       = "${var.scan_script_name}.lambda_handler"
  runtime       = var.lambda_runtime

  tags = {
        Name = var.lambda_scan_script_name
        Projeto = "QuickStart",
        Environment = "desenvolvimento"
   }

  depends_on = [
    aws_dynamodb_table.dynamodbtable,
  ]

}
    