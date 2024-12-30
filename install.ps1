# Ensure user is in their home directory
$homeDirectory = [Environment]::GetFolderPath("UserProfile")
Set-Location -Path $homeDirectory

# Install Node.js v20 and Git using Winget
winget install -e --id OpenJS.NodeJS
winget install -e --id Git.Git

# Install pnpm using npm and update PATH
powershell -ExecutionPolicy Bypass -Command "& { npm install -g pnpm@9.1.0 }"
$env:Path += ";" + (npm prefix -g | ForEach-Object { "$_\node_modules\.bin" })
pnpm --version  # Ensure pnpm is installed correctly

# Clone the Vencord repository
git clone https://github.com/hellsuck/vencordradiant.git

# Kill all Discord clients to prevent installer issues
Stop-Process -Name Discord -Force -ErrorAction SilentlyContinue
Stop-Process -Name DiscordCanary -Force -ErrorAction SilentlyContinue
Stop-Process -Name DiscordPTB -Force -ErrorAction SilentlyContinue

# Navigate to the cloned repository directory and run the installer
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
Set-Location vencordradiant\
powershell -ExecutionPolicy Bypass -Command "& { pnpm install; pnpm run build; pnpm run inject }"

# Final output messages
Write-Output "If you followed the instructions correctly, the installer should have completed successfully."
Write-Output "You'll need to make sure to enable the plugin (Radiant Tweaks) in the Vencord settings inside of Discord > Settings > Plugins > Radiant Tweaks and turn the switch on and click restart."
