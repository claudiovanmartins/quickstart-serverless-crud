
#api-gateway
resource "aws_api_gateway_rest_api" "api-gtw-movies" {
  name = var.apigw-rest-api-name
  description = var.apigw-rest-api-decription

  endpoint_configuration {
    types = ["REGIONAL"]
  }

  depends_on = [
    aws_lambda_function.put_movie_lambda,
    aws_lambda_function.scan_movie_lambda
  ]
}

#resource
resource "aws_api_gateway_resource" "resource" {
  rest_api_id = "${aws_api_gateway_rest_api.api-gtw-movies.id}"
  parent_id = "${aws_api_gateway_rest_api.api-gtw-movies.root_resource_id}"
  path_part = "movies"
}

resource "aws_api_gateway_resource" "v1" {
  rest_api_id = "${aws_api_gateway_rest_api.api-gtw-movies.id}"
  parent_id = "${aws_api_gateway_resource.resource.id}"
  path_part = "v1"
}

#put - methods
resource "aws_api_gateway_method" "putmethod" {
  rest_api_id = "${aws_api_gateway_rest_api.api-gtw-movies.id}"
  resource_id = "${aws_api_gateway_resource.v1.id}"
  http_method = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "putintegration" {
  rest_api_id = "${aws_api_gateway_rest_api.api-gtw-movies.id}"
  resource_id = "${aws_api_gateway_resource.v1.id}"
  http_method = "${aws_api_gateway_method.putmethod.http_method}"
  integration_http_method = "POST"
  type = "AWS"
  uri = "${aws_lambda_function.put_movie_lambda.invoke_arn}"
}

resource "aws_api_gateway_method_response" "putmethodresponse" {
  rest_api_id = "${aws_api_gateway_rest_api.api-gtw-movies.id}"
  resource_id = "${aws_api_gateway_resource.v1.id}"
  http_method = "${aws_api_gateway_method.putmethod.http_method}"
  status_code = "200"
  response_models = {
       "application/json" = "Empty"
   }
}

resource "aws_api_gateway_integration_response" "putmethodintegrationresponse" {
  rest_api_id = aws_api_gateway_rest_api.api-gtw-movies.id
  resource_id = aws_api_gateway_resource.v1.id
  http_method = aws_api_gateway_method.putmethod.http_method
  status_code = aws_api_gateway_method_response.putmethodresponse.status_code
}

resource "aws_lambda_permission" "apigw_lambda_put"{
  statement_id = "AllowExecutionFromAPIGateway"
  action = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.put_movie_lambda.function_name}" 
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.api-gtw-movies.execution_arn}/*/*/*"
}

#scan - methods
resource "aws_api_gateway_method" "scanmethod" {
  rest_api_id = "${aws_api_gateway_rest_api.api-gtw-movies.id}"
  resource_id = "${aws_api_gateway_resource.v1.id}"
  http_method = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "scanintegration" {
  rest_api_id = "${aws_api_gateway_rest_api.api-gtw-movies.id}"
  resource_id = "${aws_api_gateway_resource.v1.id}"
  http_method = "${aws_api_gateway_method.scanmethod.http_method}"
  integration_http_method = "POST"
  type = "AWS"
  uri = "${aws_lambda_function.scan_movie_lambda.invoke_arn}"
}

resource "aws_api_gateway_method_response" "scanmethodresponse" {
  rest_api_id = "${aws_api_gateway_rest_api.api-gtw-movies.id}"
  resource_id = "${aws_api_gateway_resource.v1.id}"
  http_method = "${aws_api_gateway_method.scanmethod.http_method}"
  status_code = "200"
  response_models = {
       "application/json" = "Empty"
   }
}

resource "aws_api_gateway_integration_response" "scanmethodintegrationresponse" {
  rest_api_id = aws_api_gateway_rest_api.api-gtw-movies.id
  resource_id = aws_api_gateway_resource.v1.id
  http_method = aws_api_gateway_method.scanmethod.http_method
  status_code = aws_api_gateway_method_response.scanmethodresponse.status_code
}

resource "aws_lambda_permission" "apigw_lambda_scan"{
  statement_id = "AllowExecutionFromAPIGateway"
  action = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.scan_movie_lambda.function_name}" 
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.api-gtw-movies.execution_arn}/*/*/*"
}

#deployment
resource "aws_api_gateway_deployment" "deployment" {
  depends_on = [
    aws_api_gateway_method.putmethod,
    aws_api_gateway_integration.putintegration,
    aws_api_gateway_method.scanmethod,
    aws_api_gateway_integration.scanintegration  
  ]
  rest_api_id = "${aws_api_gateway_rest_api.api-gtw-movies.id}"
  stage_name = "dev"
}