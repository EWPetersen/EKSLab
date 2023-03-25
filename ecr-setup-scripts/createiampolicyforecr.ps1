# Prompt for the name of the ECR repository
$repoName = Read-Host "Enter the name of the ECR repository:"

# Define the IAM policy name and file path
$policyName = "ECR-$repoName-Access"
$policyFile = "$policyName.json"

# Create the IAM policy file
@"
{
    `"Version`": `"2012-10-17`",
    `"Statement`": [
        {
            `"Sid`": `"AllowECRAccess`",
            `"Effect`": `"Allow`",
            `"Action`": [
                `"ecr:GetAuthorizationToken`",
                `"ecr:BatchCheckLayerAvailability`",
                `"ecr:GetDownloadUrlForLayer`",
                `"ecr:GetRepositoryPolicy`",
                `"ecr:DescribeRepositories`",
                `"ecr:ListImages`",
                `"ecr:DescribeImages`",
                `"ecr:BatchGetImage`"
            ],
            `"Resource`": `"arn:aws:ecr:*:*:repository/$repoName`"
        }
    ]
}
"@ | Set-Content $policyFile

# Create the IAM policy
aws iam create-policy --policy-name $policyName --policy-document file://$policyFile

# Clean up the IAM policy file
Remove-Item $policyFile
