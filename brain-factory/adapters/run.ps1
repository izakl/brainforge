#!/usr/bin/env pwsh
# Windows dispatcher: run <task-id> [args...]
# Resolves the task id to its platform entrypoint via tasks.json and execs it.
#
#   ./run.ps1 inspect-repo --repo C:\path\to\repo --out gap.md
#   ./run.ps1 apply-brain provision --dest C:\tmp\new --name X --slug x ...
#   $env:PLATFORM='bash'; ./run.ps1 inspect-repo --repo ...   # force a platform
[CmdletBinding()]
param(
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$TaskId,

    [Parameter(ValueFromRemainingArguments = $true)]
    [string[]]$Args
)

$ErrorActionPreference = 'Stop'

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$TasksJson = Join-Path $ScriptDir 'tasks.json'

$Platform = $env:PLATFORM
if (-not $Platform) { $Platform = 'powershell' }

$data = Get-Content -Raw -Path $TasksJson | ConvertFrom-Json
$tasks = $data.tasks
if (-not ($tasks.PSObject.Properties.Name -contains $TaskId)) {
    $known = ($tasks.PSObject.Properties.Name) -join ', '
    Write-Error "unknown task: $TaskId (known: $known)"
    exit 3
}

$entry = $tasks.$TaskId.$Platform
if (-not $entry) {
    Write-Error "task $TaskId has no entrypoint for platform $Platform"
    exit 4
}

$entryPath = Join-Path $ScriptDir $entry
if (-not (Test-Path $entryPath)) {
    Write-Error "entrypoint not found: $entryPath"
    exit 5
}

switch -Wildcard ($entryPath) {
    '*.ps1' { & pwsh $entryPath @Args; exit $LASTEXITCODE }
    '*.sh'  { & bash $entryPath @Args; exit $LASTEXITCODE }
    default { & $entryPath @Args; exit $LASTEXITCODE }
}
