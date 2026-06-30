param(
  [string]$Message = "Update digital teaching material skill",
  [string]$GitHubUser = "prayer168"
)

$ErrorActionPreference = "Stop"

$skillDir = Split-Path -Parent $PSScriptRoot
$repoName = Split-Path -Leaf $skillDir
$quickValidate = Join-Path $env:USERPROFILE ".codex\skills\.system\skill-creator\scripts\quick_validate.py"

Push-Location $skillDir
try {
  if (-not (Test-Path -LiteralPath ".git")) {
    git init -b main | Out-Host
  }

  $env:PYTHONUTF8 = "1"
  python $quickValidate $skillDir | Out-Host

  $status = git status --porcelain
  if (-not $status) {
    Write-Host "No skill changes to publish."
    exit 0
  }

  git add -A
  git commit -m $Message | Out-Host

  $remote = ""
  try {
    $remote = git remote get-url origin 2>$null
  } catch {
    $remote = ""
  }

  if (-not $remote) {
    gh repo create "$GitHubUser/$repoName" --public --source . --remote origin --push | Out-Host
  } else {
    git push | Out-Host
  }
} finally {
  Pop-Location
}
