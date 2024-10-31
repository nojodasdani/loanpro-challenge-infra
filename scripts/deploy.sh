#!/bin/bash

# Parameters
PROJECT_NAME="loanpro-challenge"
ENVIRONMENT="dev"
TEMPLATE_FILE="./cloudformation/main.yaml"
REGION="ca-central-1"

# Validate the CloudFormation template
echo "Validating CloudFormation template..."
aws cloudformation validate-template --template-body file://$TEMPLATE_FILE
if [ $? -ne 0 ]; then
    echo "Template validation failed."
    exit 1
fi
echo "Template validation succeeded."

# Deploy the CloudFormation stack
echo "Deploying CloudFormation stack..."
aws cloudformation deploy \
    --template-file $TEMPLATE_FILE \
    --stack-name $PROJECT_NAME \
    --capabilities CAPABILITY_NAMED_IAM \
    --region $REGION \
    --parameter-overrides Project="$PROJECT_NAME" Environment="$ENVIRONMENT"

if [ $? -eq 0 ]; then
    echo "CloudFormation stack deployed successfully."
else
    echo "CloudFormation stack deployment failed."
    exit 1
fi
