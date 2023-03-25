# Prompt for the name of the IAM policy
$policyName = Read-Host "Enter the name of the IAM policy to attach:"

# Get the current IAM user's ARN
$currentUserName = aws iam get-user --profile IAM --query 'User.UserName' --output text
$currentARN = aws iam get-user --profile IAM --query 'User.Arn' --output text

# Attach the IAM policy to the current user, if it is not already attached
$iamPolicyARN = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
$iamHasPolicy = (aws iam list-attached-user-policies --user-name $currentUserName --query 'AttachedPolicies[].PolicyArn' --output text) -contains $iamPolicyARN

if ($iamHasPolicy) {
    Write-Host "The IAM policy $iamPolicyARN is already attached to the IAM user $currentUserName."
} else {
    Write-Host "The IAM policy $iamPolicyARN is not attached to the IAM user $currentUserName. Attaching the IAM policy $iamPolicyARN."

    # Attach the IAM policy to the IAM user
    aws iam attach-user-policy --user-name $currentUserName --policy-arn $iamPolicyARN

    Write-Host "The IAM policy $iamPolicyARN has been attached to the IAM user $currentUserName."
}

# Attach the specified IAM policy to the current user
aws iam attach-user-policy --user-name $currentUserName --policy-arn "arn:aws:iam::$(aws sts get-caller-identity --query 'Account' --output text):policy/$policyName"
