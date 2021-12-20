import boto3
from boto3.dynamodb.conditions import Key
from botocore.exceptions import ClientError

def lambda_handler(event, context):

    dynamodb = boto3.resource('dynamodb')

    table = dynamodb.Table('Movies')

    try:
        response = table.scan() 
    except ClientError as e:
        print(e.response['Error']['Message'])
    else:
        return response['Items']
