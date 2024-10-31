#!/bin/bash

# Parameters
PROJECT_NAME="loanpro-challenge"
ENVIRONMENT="dev"
TEMPLATE_FILE="main.yaml"
REGION="ca-central-1"
# NOTE: Change next value to an existing Bucket where the cfn templates will be uploaded
# NOTE2: Deployment and bucket regions region must be the same and should be different than us-east-1
BUCKET_NAME="loanpro-challenge-iac-artifacts"
BUCKET_URL="https://$BUCKET_NAME.s3.$REGION.amazonaws.com"

# Validate the CloudFormation template
echo "Validating CloudFormation templates..."
aws cloudformation validate-template --template-body file://../cloudformation/$TEMPLATE_FILE

if [ $? -ne 0 ]; then
    echo "Template validation failed."
    exit 1
fi
echo "Template validation succeeded."

# Upload local files to S3 bucket for deployment
aws s3 sync ../cloudformation s3://$BUCKET_NAME --exact-timestamps

# Deploy the CloudFormation stack
echo "Deploying CloudFormation stack..."
    # --template-file s3://$BUCKET_NAME/$TEMPLATE_FILE \
aws cloudformation deploy \
    --template-file ../cloudformation/$TEMPLATE_FILE \
    --stack-name $PROJECT_NAME \
    --capabilities CAPABILITY_NAMED_IAM CAPABILITY_AUTO_EXPAND \
    --region $REGION \
    --parameter-overrides Project="$PROJECT_NAME" Environment="$ENVIRONMENT" BucketUrl="$BUCKET_URL"

if [ $? -eq 0 ]; then
    echo "CloudFormation stack deployed successfully."
else
    echo "CloudFormation stack deployment failed."
    exit 1
fi
