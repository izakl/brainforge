#!/usr/bin/env pwsh
# Thin wrapper over `python -m brainfactory`. The first argument selects the
# subcommand (provision | adopt); the rest pass through unchanged.
[CmdletBinding()]
param(
    [Parameter(ValueFromRemainingArguments = $true)]
    [string[]]$Args
)

$ErrorActionPreference = 'Stop'

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$PyDir = (Resolve-Path (Join-Path $ScriptDir '..' 'python')).Path

$PythonBin = $env:PYTHON_BIN
if (-not $PythonBin) {
    foreach ($candidate in @('python3', 'python')) {
        if (Get-Command $candidate -ErrorAction SilentlyContinue) {
            $PythonBin = $candidate
            break
        }
    }
}
if (-not $PythonBin) {
    Write-Error 'python not found on PATH'
    exit 127
}

if (-not $Args -or $Args.Count -lt 1) {
    Write-Error 'usage: apply.ps1 <provision|adopt> [args...]'
    exit 2
}

if ($env:PYTHONPATH) {
    $env:PYTHONPATH = "$PyDir$([IO.Path]::PathSeparator)$($env:PYTHONPATH)"
} else {
    $env:PYTHONPATH = $PyDir
}

& $PythonBin -m brainfactory @Args
exit $LASTEXITCODE
