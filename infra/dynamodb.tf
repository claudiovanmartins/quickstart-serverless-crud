resource "aws_dynamodb_table" "dynamodbtable" {
    name = var.table_name
    billing_mode = var.table_billing_mode
    read_capacity = 1
    write_capacity = 1
    hash_key = var.table_hash_key
    range_key = var.table_range_key

    attribute {
      name = var.table_hash_key
      type = "S"
    }

    attribute {
      name = var.table_range_key
      type = "S"
    }

    tags = {
      "Name" = "Table-${var.table_name}"
      "Environment" = "desenvolvimento"
    }
}