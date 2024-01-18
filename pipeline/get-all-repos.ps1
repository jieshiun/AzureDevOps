# 請確保已安裝 Azure DevOps CLI。你可以在 Azure DevOps CLI 的官方文件 中找到安裝指南。
# https://learn.microsoft.com/zh-tw/cli/azure/install-azure-cli-windows?tabs=azure-cli

# 請先執行 az login 
# az login 
$organization = "your_organization"

$projects = az devops project list --organization https://dev.azure.com/$organization --output json | ConvertFrom-Json

$filePath = "repolist.txt"

if (Test-Path $filePath)
{
  Remove-Item $filePath -verbose
}

$indent = " " * 12

Write-Host "projects:"
Write-Output "$($indent)projects:" >> repolist.txt

foreach($project in $projects.value)
{
  $repos = az repos list --organization https://dev.azure.com/$organization --project $project.name --output json | ConvertFrom-Json

  Write-Host "  - name: '$($project.name)'" 
  Write-Output "$($indent)  - name: '$($project.name)'" >> repolist.txt

  Write-Host "    repositories:"
  Write-Output "$($indent)    repositories:" >> repolist.txt

  foreach($repo in $repos)
  {
    if(-Not $repo.isDisabled)
    {
      Write-Host "    - '$($repo.name)'"
      Write-Output "$($indent)    - '$($repo.name)'" >> repolist.txt
    }
  }
}