variable "aws_region" {
    description = "AWS Região default"
    default = "us-west-2" 
}

variable "table_name" {
    description = "Nome da taela"
    default = "Movies"
}

variable "table_arn" {
    description = "ARN da tabela criada"
    default = ""
}

variable "table_billing_mode" {
    description = "Capacity Mode"
    default = "PROVISIONED"
}

variable "table_hash_key" {
    description = "usada para distribuir os dados"
    default = "Actor"
}

variable "table_range_key" {
    description = "usada para ajudar nas consultas"
    default = "Title"
}

variable "table_atributes_key" {
    description = "usada para adicionar os outros atributos"
    default = "Info"
}

variable "put_script_name" {
    description = "nome do script python da lambda de insert"
    default = "putmovies"
}

variable "lambda_put_script_name" {
    description = "nome da lambda que receberá o script python de insert"
    default = "put_movie_lambda"
}

variable "lambda_put_script_description" {
    description = "descrição da lambda"
    default = "Lambda criada para executar inserts na tabela Movies"
}

variable "get_script_name" {
    description = "nome do script python da lambda de get"
    default = "getmovies"
}

variable "scan_script_name" {
    description = "nome do script python da lambda de scan"
    default = "scanmovies"
}

variable "lambda_get_script_name" {
    description = "nome da lambda que receberá o script python de get"
    default = "get_movie_lambda"
}

variable "lambda_get_script_description" {
    description = "descrição da lambda"
    default = "Lambda criada para executar selects na tabela Movies"
}

variable "lambda_scan_script_name" {
    description = "nome da lambda que receberá o script python de scan"
    default = "scan_movie_lambda"
}

variable "lambda_scan_script_description" {
    description = "descrição da lambda"
    default = "Lambda criada para executar scan na tabela Movies"
}

variable "lambda_runtime" {
    description = "runtime da lambda"
    default = "python3.8"
}

variable "apigw-rest-api-name" {
  description = "nome do api gateway"
  default = "api-gtw-movies"
}

variable "apigw-rest-api-decription" {
    description = "descrição da lambda do api gateway"
    default = "API Gateway para Movie API"
}