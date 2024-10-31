#!/bin/bash
source set_vars.sh

REGIONS=("us-east-1" "ca-central-1")

for REGION in "${REGIONS[@]}"; do
    echo "Starting deployment for region: $REGION"

    # Validate the CloudFormation template
    echo "Validating CloudFormation template for $REGION..."

    aws cloudformation validate-template --template-body file://../cloudformation/$REGION/$TEMPLATE_FILE

    if [ $? -ne 0 ]; then
        echo "$REGION Template validation failed."
        exit 1
    fi

    echo "$REGION Template validation succeeded."

    # Upload local files to S3 bucket for deployment
    echo "Uploading files to S3 bucket for $REGION..."
    aws s3 sync ../cloudformation/$REGION s3://$BUCKET_NAME/$REGION --exact-timestamps

    # Deploy the CloudFormation stack
    echo "Deploying CloudFormation stack for $REGION..."

    aws cloudformation deploy \
        --template-file ../cloudformation/$REGION/$TEMPLATE_FILE \
        --stack-name $PROJECT_NAME \
        --capabilities CAPABILITY_NAMED_IAM CAPABILITY_AUTO_EXPAND \
        --region $REGION \
        --parameter-overrides Project="$PROJECT_NAME" Environment="$ENVIRONMENT" BucketUrl="$BUCKET_DOMAIN_NAME/$REGION"

    if [ $? -eq 0 ]; then
        echo "CloudFormation stack deployed successfully in $REGION."
    else
        echo "CloudFormation stack deployment failed in $REGION."
        exit 1
    fi
done

echo "Deployment completed for all specified regions."
