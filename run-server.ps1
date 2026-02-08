# Simple helper to start a detached Python HTTP server from the project folder.
# Behavior:
# - finds an available port starting at 8000
# - prefers `py -3` if available, otherwise `python`
# - starts the server detached and writes the PID to http-server.pid
# - opens the default browser to the server URL

$ErrorActionPreference = 'Stop'

#$dir: the directory to serve (the script's folder)
$dir = (Get-Location).Path

$port = 8000
function PortInUse($p) {
	return (netstat -aon | Select-String ":$p(\s|$)" ) -ne $null
}

while (PortInUse $port) { $port++ }

if (Get-Command py -ErrorAction SilentlyContinue) {
	$exe = 'py'
	$args = "-3 -m http.server $port --directory `"$dir`""
} elseif (Get-Command python -ErrorAction SilentlyContinue) {
	$exe = 'python'
	$args = "-m http.server $port --directory `"$dir`""
} else {
	Write-Error "Python not found in PATH. Please install Python or run a static server by another tool."
	exit 1
}

Write-Output "Starting HTTP server using: $exe $args"

# Start detached process and capture PID
$proc = Start-Process -FilePath $exe -ArgumentList $args -WorkingDirectory $dir -WindowStyle Hidden -PassThru
Start-Sleep -Seconds 1

if (PortInUse $port) {
	Write-Output "Server started on http://localhost:$port/ (PID $($proc.Id))"
	Set-Content -Path (Join-Path $dir 'http-server.pid') -Value $proc.Id -Force
	try { Start-Process "http://localhost:$port/" } catch { Write-Output "Could not open browser automatically." }
} else {
	Write-Error "Failed to start server. Check that Python can be started from PowerShell and try running: $exe $args"
}

