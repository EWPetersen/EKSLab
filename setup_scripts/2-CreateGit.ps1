# Prompt the user for the project name
$projectName = Read-Host "Enter the project name"

# Prompt the user for the working directory
$workingDirectory = Read-Host "Enter the working directory"

# Create the folder with the project name in the working directory
$projectPath = Join-Path $workingDirectory $projectName
New-Item -ItemType Directory -Path $projectPath -Force

# Navigate to the project directory
Set-Location $projectPath

# Create a new file to track
New-Item -ItemType File -Name "README.md"

# Initialize a new Git repository in the project directory
git init

# Add and commit the README file
Write-Output "Hello, World!" > README.md
git add .
git commit -m "Add README file"

# Load the environment variables from file
$envFile = Get-Content "D:\GitHub\scripts\gitenvcreds.env" -Raw | ConvertFrom-StringData
$accessToken = $envFile.accessToken
$owner = $envFile.owner

# Check if the access token and owner variables have been set correctly
Write-Host "Access Token: $accessToken"
Write-Host "Owner: $owner"

# Create a new GitHub repository using the GitHub API
$url = "https://api.github.com/user/repos"
$body = @{
    name = $projectName
}
$headers = @{
    Authorization = "Bearer $accessToken"
    "Content-Type" = "application/json"
}

$response = Invoke-RestMethod -Method Post -Uri $url -Body ($body | ConvertTo-Json -Depth 3) -Headers $headers

# Set up the Git repository to track the remote GitHub repository
$remoteUrl = $response.html_url + ".git"
git remote add origin $remoteUrl

# Push the initial commit to the GitHub repository
git push -u origin master

# Success message
Write-Host "Repository created at $remoteUrl and initialized in $projectPath"
