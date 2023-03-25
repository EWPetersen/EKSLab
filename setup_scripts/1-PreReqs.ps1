# Check Get-ExecutionPolicy and set it to RemoteSigned if needed
$policy = Get-ExecutionPolicy
if ($policy -ne 'RemoteSigned') {
    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
    if ($?) {
        Write-Host "Set-ExecutionPolicy: PASS"
    } else {
        Write-Host "Set-ExecutionPolicy: FAIL"
    }
} else {
    Write-Host "Get-ExecutionPolicy: PASS"
}

# Check for AWS CLI version and install it if needed
if (!(Get-Command aws -ErrorAction SilentlyContinue)) {
    $awsCliUrl = "https://awscli.amazonaws.com/AWSCLIV2.msi"
    Write-Host "Installing AWS CLI..."
    Start-Process "msiexec.exe" -ArgumentList "/i $awsCliUrl /quiet" -Wait
    if (Get-Command aws -ErrorAction SilentlyContinue) {
        $awsVersion = aws --version
        Write-Host "AWS CLI $awsVersion : PASS"
    } else {
        Write-Host "AWS CLI: FAIL"
    }
} else {
    $awsVersion = aws --version
    Write-Host "AWS CLI $awsVersion : PASS"
}

# Check for kubectl version and install it if needed
if (!(Get-Command kubectl -ErrorAction SilentlyContinue)) {
    $kubectlUrl = "https://s3.us-west-2.amazonaws.com/amazon-eks/1.25.6/2023-01-30/bin/windows/amd64/kubectl.exe"
    Write-Host "Installing kubectl..."
    Invoke-WebRequest -Uri $kubectlUrl -OutFile "kubectl.exe"
    Move-Item .\kubectl.exe -Destination $env:USERPROFILE\bin\kubectl.exe
    if (Get-Command kubectl -ErrorAction SilentlyContinue) {
        $kubectlVersion = kubectl version --client --short=true
        Write-Host "kubectl $kubectlVersion : PASS"
    } else {
        Write-Host "kubectl: FAIL"
    }
} else {
    $kubectlVersion = kubectl version --client --short=true
    Write-Host "kubectl $kubectlVersion : PASS"
}

# Check for eksctl version and install it if needed
if (!(Get-Command eksctl -ErrorAction SilentlyContinue)) {
    Write-Host "Installing eksctl..."
    Start-Process "choco.exe" -ArgumentList "install eksctl -y" -Wait
    if (Get-Command eksctl -ErrorAction SilentlyContinue) {
        $eksctlVersion = eksctl version
        Write-Host "eksctl $eksctlVersion : PASS"
    } else {
        Write-Host "eksctl: FAIL"
    }
} else {
    $eksctlVersion = eksctl version
    Write-Host "eksctl $eksctlVersion : PASS"
}

# Check for Terraform version and install it if needed
if (!(Get-Command terraform -ErrorAction SilentlyContinue)) {
    Write-Host "Installing Terraform..."
    Start-Process "choco.exe" -ArgumentList "install terraform -y" -Wait
    if (Get-Command terraform -ErrorAction SilentlyContinue) {
        $terraformVersion = terraform version
        Write-Host "Terraform $terraformVersion : PASS"
    } else {
        Write-Host "Terraform: FAIL"
    }
}

# Check for gh version and install it if needed
if (!(Get-Command gh -ErrorAction SilentlyContinue)) {
    Write-Host "Installing GitHub CLI..."
    Start-Process "choco.exe" -ArgumentList "install gh -y" -Wait
    if (Get-Command gh -ErrorAction SilentlyContinue) {
        $ghVersion = gh --version
        Write-Host "GitHub CLI $ghVersion : PASS"
    } else {
        Write-Host "GitHub CLI: FAIL"
    }
} else {
    $ghVersion = gh --version
    Write-Host "GitHub CLI $ghVersion : PASS"
}

# Check for Docker CLI version and install it if needed
if (!(Get-Command docker -ErrorAction SilentlyContinue)) {
    Write-Host "Docker CLI is not installed."
    $choice = Read-Host "Do you want to install Docker? (y/n)"
    if ($choice -eq 'y') {
        $dockerUrl = "https://desktop.docker.com/win/stable/Docker%20Desktop%20Installer.exe"
        Write-Host "Downloading Docker installer..."
        Invoke-WebRequest -Uri $dockerUrl -OutFile "Docker Desktop Installer.exe"
        Write-Host "Starting Docker installer..."
        Start-Process ".\Docker Desktop Installer.exe" -ArgumentList "/silent" -Wait
        if (Get-Command docker -ErrorAction SilentlyContinue) {
            $dockerVersion = docker --version
            Write-Host "Docker CLI $dockerVersion : PASS"
        } else {
            Write-Host "Docker CLI: FAIL"
        }
    } else {
        Write-Host "Docker CLI: FAIL"
    }
} else {
    $dockerVersion = docker --version
    Write-Host "Docker CLI $dockerVersion : PASS"
}

# Check for Git version and prompt to install if needed
if (!(Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Host "Git is not installed."
    $choice = Read-Host "Do you want to install Git? (y/n)"
    if ($choice -eq 'y') {
        Start-Process "https://git-scm.com/download/win" -Wait
        if (Get-Command git -ErrorAction SilentlyContinue) {
            $gitVersion = git --version
            Write-Host "Git $gitVersion : PASS"
        } else {
            Write-Host "Git: FAIL"
        }
    } else {
        Write-Host "Git: FAIL"
    }
} else {
    $gitVersion = git --version
    Write-Host "Git $gitVersion : PASS"
}
