param(
  [string]$Message = "Update digital teaching material skill",
  [string]$GitHubUser = "prayer168"
)

$ErrorActionPreference = "Stop"

$skillDir = Split-Path -Parent $PSScriptRoot
$repoName = Split-Path -Leaf $skillDir
$quickValidate = Join-Path $env:USERPROFILE ".codex\skills\.system\skill-creator\scripts\quick_validate.py"

function Install-AutoPushHook {
  $hookDir = Join-Path $skillDir ".git\hooks"
  if (-not (Test-Path -LiteralPath $hookDir)) {
    return
  }

  $hookPath = Join-Path $hookDir "post-commit"
  $hook = @'
#!/bin/sh
git rev-parse --abbrev-ref --symbolic-full-name @{u} >/dev/null 2>&1 || exit 0
git push
'@
  Set-Content -LiteralPath $hookPath -Value $hook -Encoding ASCII
}

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

  Install-AutoPushHook
} finally {
  Pop-Location
}
