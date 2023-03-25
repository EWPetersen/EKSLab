# Get the AWS account ID
$awsAccountId = (aws sts get-caller-identity --query 'Account' --output text)

# Get the ECR registry URL
$ecrUrl = "$awsAccountId.dkr.ecr.us-west-2.amazonaws.com"

# Authenticate with the ECR registry
$ecrLoginCommand = "aws ecr get-login-password --region us-west-2 | docker login --username AWS --password-stdin $ecrUrl"
Invoke-Expression $ecrLoginCommand

# Verify that the login was successful
if ($LASTEXITCODE -eq 0) {
    Write-Host "The AWS CLI can authenticate with the ECR registry."
} else {
    Write-Host "The AWS CLI cannot authenticate with the ECR registry."
}
