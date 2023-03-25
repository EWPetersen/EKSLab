# Prompt for the name of the ECR repository
$repoName = Read-Host "Enter the name of the ECR repository:"

# Verify that the IAM user has the required ECR permissions
$iamUserName = aws sts get-caller-identity --profile IAM --query 'Arn' --output text | %{ $_.Split("/")[-1] }
$iamPolicyARN = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
$iamHasPolicy = aws iam list-attached-user-policies --user-name $iamUserName --query 'AttachedPolicies[].PolicyArn' --output text | %{ $_.Contains($iamPolicyARN) }

if ($iamHasPolicy) {
    Write-Host "The IAM user $iamUserName has the required ECR permissions."
} else {
    Write-Host "The IAM user $iamUserName does not have the required ECR permissions."
}
