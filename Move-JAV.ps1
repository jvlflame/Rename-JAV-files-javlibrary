function Move-JAVFiles {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true, Position=0)]
        [System.IO.FileInfo]$FilePath,
        [Parameter(Mandatory=$true, Position=1)]
        [int]$FileSize, # greater than in MB
    )

    # Get all video files (.mp4, .avi, .mkv, .wmv) in the $FilePath directory greater than $FileSize
    $Files = Get-ChildItem -Path $FilePath -Recurse | Where-Object {
        $_.Name -like "*.mp4"`
        -or $_.Name -like "*.avi"`
        -or $_.Name -like "*.mkv"`
        -or $_.Name -like "*.wmv"`
        -and $_.Length -ge ($FileSize * 1MB)
    }
    
    # Move video files
    $Files | Move-Item -Destination $DestinationPath -Verbose
    
    # Delete everything else
    Get-ChildItem -Path $FilePath -Recurse | Remove-Item -Recurse -Verbose
}
