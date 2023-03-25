param (
    [Parameter(Mandatory=$true)]
    [string]$Region
)

# List all IAM users with Administrator privileges
try {
    $adminPolicyArn = "arn:aws:iam::aws:policy/AdministratorAccess"
    $iamUsers = aws iam list-users --output json --region $Region | ConvertFrom-Json
    Write-Host "IAM users with Administrator privileges:"

    foreach ($user in $iamUsers.Users) {
        $attachedPolicies = aws iam list-attached-user-policies --user-name $user.UserName --output json --region $Region | ConvertFrom-Json
        foreach ($policy in $attachedPolicies.AttachedPolicies) {
            if ($policy.PolicyArn -eq $adminPolicyArn) {
                Write-Host $user.UserName
            }
        }
    }
}
catch {
    Write-Host "Error listing IAM users with Administrator privileges: $($_.Exception.Message)"
}

# Prompt the user for the admin account name
$AdminUserName = Read-Host -Prompt 'Enter the admin account name'

# Create IAM Admin user
try {
    $iamUser = aws iam create-user --user-name $AdminUserName --output json --region $Region | ConvertFrom-Json
    Write-Host "IAM user '$($iamUser.User.UserName)' created successfully."
    
    # Attach policies to IAM user
    aws iam attach-user-policy --user-name $AdminUserName --policy-arn arn:aws:iam::aws:policy/AmazonEKSClusterPolicy --region $Region
    Write-Host "AmazonEKSClusterPolicy attached to IAM user '$($iamUser.User.UserName)'."
    
    aws iam attach-user-policy --user-name $AdminUserName --policy-arn arn:aws:iam::aws:policy/AdministratorAccess --region $Region
    Write-Host "AdministratorAccess policy attached to IAM user '$($iamUser.User.UserName)'."
    
    # Create access keys for IAM user
    $accessKey = aws iam create-access-key --user-name $AdminUserName --output json --region $Region | ConvertFrom-Json
    Write-Host "Access Key ID: $($accessKey.AccessKey.AccessKeyId)"
    Write-Host "Secret Access Key: $($accessKey.AccessKey.SecretAccessKey)"
}
catch {
    Write-Host "Error creating IAM Admin user: $($_.Exception.Message)"
}
