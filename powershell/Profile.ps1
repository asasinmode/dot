oh-my-posh init pwsh --config "D:\Projects\dot\powershell\asasinmode.omp.json" | Invoke-Expression

fnm env --corepack-enabled | Out-String | Invoke-Expression

Import-Module -Name Terminal-Icons
Import-Module PSReadLine

Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -PredictionViewStyle ListView
Set-PSReadLineOption -EditMode Windows

Function CDNvim {Set-Location -Path "$env:LocalAppData\nvim"}
Function CDProjects {Set-Location -Path "D:\projects"}

Set-Alias -Name nvimrc -Value CDNvim
Set-Alias -Name projects -Value CDProjects
