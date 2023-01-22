from datetime import datetime

def about(event, context):
    response = {
        "statusCode": 200,
        "headders": {"content-type": "application/json"},
        "body":{
            "welcome": "This is an API graphql example",
            "tech": ["terraform", "aws_lambda", "graphql"],
            "request": event.get('httpMethod')}
    }
    return response
