import boto3
from boto3.dynamodb.conditions import Key
from botocore.exceptions import ClientError

def lambda_handler(event, context):

    dynamodb = boto3.resource('dynamodb')

    table = dynamodb.Table('Movies')

    try:
        response = table.put_item(
            Item={
                'Actor': event["actor"], 
                'Title': event["title"],
                'Info': {
                    "year": event["year"],
                    "genre": event["genre"]
                }
            }
        ) 
    except ClientError as e:
        return e.response['Error']['Message']
    else:
        return response

