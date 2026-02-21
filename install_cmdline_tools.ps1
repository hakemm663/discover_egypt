param(
    [string]$AndroidSdkRoot = "$env:LOCALAPPDATA\Android\Sdk",
    [string]$ToolsPackageUrl = "https://dl.google.com/android/repository/commandlinetools-win-11076708_latest.zip"
)

$ErrorActionPreference = "Stop"

Write-Host "Android SDK root: $AndroidSdkRoot"

# Create SDK directory if it doesn't exist
if (-not (Test-Path $AndroidSdkRoot)) {
    New-Item -ItemType Directory -Path $AndroidSdkRoot -Force | Out-Null
}

$tempRoot = Join-Path $env:TEMP "discover-egypt-sdk-fix"
$zipPath = Join-Path $tempRoot "commandlinetools.zip"
$extractPath = Join-Path $tempRoot "extracted"
$cmdlineToolsRoot = Join-Path $AndroidSdkRoot "cmdline-tools"
$latestPath = Join-Path $cmdlineToolsRoot "latest"

# Clean up and create temp directory
New-Item -ItemType Directory -Path $tempRoot -Force | Out-Null
Remove-Item -Path $extractPath -Recurse -Force -ErrorAction SilentlyContinue

Write-Host "Downloading Android command-line tools..."
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Invoke-WebRequest -Uri $ToolsPackageUrl -OutFile $zipPath

Write-Host "Extracting package..."
Expand-Archive -Path $zipPath -DestinationPath $extractPath -Force

# Create cmdline-tools directory structure
if (-not (Test-Path $cmdlineToolsRoot)) {
    New-Item -ItemType Directory -Path $cmdlineToolsRoot -Force | Out-Null
}

if (Test-Path $latestPath) {
    Remove-Item -Path $latestPath -Recurse -Force
}

# Move extracted folder
Move-Item -Path (Join-Path $extractPath "cmdline-tools") -Destination $latestPath

# Set environment variables for this session
$env:ANDROID_HOME = $AndroidSdkRoot
$env:ANDROID_SDK_ROOT = $AndroidSdkRoot
$sdkManager = Join-Path $latestPath "bin\sdkmanager.bat"

if (-not (Test-Path $sdkManager)) {
    throw "sdkmanager.bat not found at $sdkManager"
}

Write-Host "Installing required Android SDK components..."
& $sdkManager --sdk_root=$AndroidSdkRoot "platform-tools" "platforms;android-36" "build-tools;36.0.0"

Write-Host "Accepting Android licenses..."
cmd /c "for /l %i in (1,1,20) do @echo y" | & $sdkManager --sdk_root=$AndroidSdkRoot --licenses

Write-Host "Done!"
