output "dynamodb_table_arn" {
  description = "ARN da tabela criada"
  value = "${aws_dynamodb_table.dynamodbtable.arn}"
}

output "lambda_arn" {
  description = "ARN da lambda criada"
  value = "${aws_lambda_function.put_movie_lambda.arn}"
}

output "apigw_rest_api_url" {
  value = aws_api_gateway_deployment.deployment.invoke_url
}