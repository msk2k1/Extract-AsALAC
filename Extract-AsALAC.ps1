[CmdletBinding()]
param (
    [Parameter(mandatory=$true)]
    [string]$Source
)
$ErrorActionPreference = "Stop"

. F:/projects/scripts/Add-Dependency.ps1
Add-Dependency "C:\Program Files\7-Zip" "7z"
Add-Dependency "F:\software" "ffmpeg"

7z e "$Source" -o"./*" # extract to folder with same name as source zip
$extraction = [string]$pwd + "\" + ((Split-Path "$source" -leaf) -replace ".{4}$")    # the folder of extracted files

foreach($i in (Get-ChildItem $extraction -Include *.flac, *.mp3, *.ogg, *.wav -Recurse)) { # -include only works if -recurse is also there
    if(($i.extension -eq ".mp3") -or ($i.extension -eq ".ogg")) {Write-Warning "Conversion for $($i.name) is from a lossy format."}
    ffmpeg -i "$extraction\$($i.Name)" -c:v copy -c:a alac "$extraction\$($i.BaseName).m4a" -hide_banner
    Remove-Item $i
}
Get-ChildItem -Path $extraction