<#
Creates a Desktop shortcut that launches PowerShell and runs `npm run start` in this project folder.
Run this script from the project folder to create the shortcut.
#>

$ErrorActionPreference = 'Stop'

$projectDir = (Get-Location).Path
$desktop = [Environment]::GetFolderPath('Desktop')
$shortcutPath = Join-Path $desktop 'Smart PDF Reader.lnk'


$psExe = Join-Path $env:SystemRoot 'System32\WindowsPowerShell\v1.0\powershell.exe'

$args = "-NoExit -WorkingDirectory `"$projectDir`" -Command npm run start"

# Ensure we have a book.ico in the project; create it programmatically if missing
$iconPath = Join-Path $projectDir 'book.ico'
if (-not (Test-Path $iconPath)) {
    try {
        Add-Type -AssemblyName System.Drawing
        $size = 64
        $bmp = New-Object System.Drawing.Bitmap $size, $size
        $g = [System.Drawing.Graphics]::FromImage($bmp)
        $g.Clear([System.Drawing.Color]::FromArgb(255,34,139,230)) # blue background

        # draw a simple book shape
        $pen = New-Object System.Drawing.Pen ([System.Drawing.Color]::White), 4
        $rect = New-Object System.Drawing.Rectangle(8,12,48,40)
        $g.DrawRectangle($pen, $rect)
        $brush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::White)
        $g.FillRectangle($brush, 12,16,20,32)

        # letter B
        $font = New-Object System.Drawing.Font('Arial',24,[System.Drawing.FontStyle]::Bold)
        $brush2 = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255,34,139,230))
        $g.DrawString('ب', $font, $brush2, 26, 12)

        $g.Flush()

        $icon = [System.Drawing.Icon]::FromHandle($bmp.GetHicon())
        $fs = [System.IO.File]::OpenWrite($iconPath)
        $icon.Save($fs)
        $fs.Close()
        $icon.Dispose()
        $g.Dispose()
        $bmp.Dispose()
        Write-Output "Created icon: $iconPath"
    } catch {
        Write-Warning "Could not create book.ico: $_"
    }
}

$wsh = New-Object -ComObject WScript.Shell
$sc = $wsh.CreateShortcut($shortcutPath)
$sc.TargetPath = $psExe
$sc.Arguments = $args
$sc.WorkingDirectory = $projectDir
$sc.WindowStyle = 1

# Prefer the generated book.ico, otherwise attempt electron.cmd, else PowerShell icon
if (Test-Path $iconPath) {
    $sc.IconLocation = $iconPath
} else {
    $electronExe = Join-Path $projectDir 'node_modules\\.bin\\electron.cmd'
    if (Test-Path $electronExe) {
        $sc.IconLocation = $electronExe
    } else {
        $sc.IconLocation = "$psExe,0"
    }
}

$sc.Save()

Write-Output "Shortcut created: $shortcutPath (icon: $($sc.IconLocation))"
