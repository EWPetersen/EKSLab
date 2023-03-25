# Prompt the user for the working directory
$workingDir = Read-Host "Enter the path to the working directory"

# Set the working directory
Set-Location $workingDir

# Prompt the user for the new Docker folder name
$dockerFolderName = Read-Host "Enter the name of the new Docker folder"

# Create a new folder with the given name under the working directory
New-Item -ItemType Directory -Name $dockerFolderName -Path $workingDir

# Set the working directory to the new folder
Set-Location $dockerFolderName

# Create a new file called Dockerfile and add the content
@"
FROM alpine
CMD ["echo", "Hello, World!"]
"@ | Out-File Dockerfile -Encoding utf8

# Build the Docker image with the Dockerfile in the current directory and tag it with the folder name
docker build -t $dockerFolderName .

# Run the Docker container with the newly created image
docker run $dockerFolderName
