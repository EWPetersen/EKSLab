# Prompt for the name of the ECR repository
$repoName = Read-Host "Enter the name of the ECR repository:"

# Get the login token for the ECR registry
$ecrRegistry = (aws ecr describe-repositories --repository-names $repoName --query 'repositories[].registryId' --output text)
$loginCmd = "aws ecr get-login-password --region $(aws configure get region) | docker login --username AWS --password-stdin $ecrRegistry.dkr.ecr.$(aws configure get region).amazonaws.com"

# Run the login command in a shell
Invoke-Expression $loginCmd

# Verify that the login was successful
if ($LASTEXITCODE -eq 0) {
    Write-Host "The AWS CLI can authenticate with the ECR registry."
} else {
    Write-Host "The AWS CLI cannot authenticate with the ECR registry."
}
