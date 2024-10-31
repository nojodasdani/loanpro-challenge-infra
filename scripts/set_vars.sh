#!/bin/bash
PROJECT_NAME="loanpro-challenge"
ENVIRONMENT="dev"
TEMPLATE_FILE="main.yaml"
# NOTE: Change next value for an existing S3 Bucket. The existing bucket must be in ca-central-1 region
BUCKET_NAME="loanpro-challenge-iac-artifacts"
BUCKET_DOMAIN_NAME="https://$BUCKET_NAME.s3.ca-central-1.amazonaws.com"
