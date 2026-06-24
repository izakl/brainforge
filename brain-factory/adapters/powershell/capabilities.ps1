#!/usr/bin/env pwsh
# Thin wrapper: locate python and run `python -m brainfactory capabilities ...`.
# All arguments are passed through unchanged.
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

if ($env:PYTHONPATH) {
    $env:PYTHONPATH = "$PyDir$([IO.Path]::PathSeparator)$($env:PYTHONPATH)"
} else {
    $env:PYTHONPATH = $PyDir
}

& $PythonBin -m brainfactory capabilities @Args
exit $LASTEXITCODE
