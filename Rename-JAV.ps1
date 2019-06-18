function Rename-JAV {
        [CmdletBinding()]
        param(
            [ValidateScript({
                if( -Not ($_ | Test-Path) ){
                    throw "File or folder does not exist"
                }
                return $true
            })]
            [Parameter(Mandatory=$true, Position=0)]
            [System.IO.FileInfo]$FilePath,
            [Parameter(Mandatory=$false, Position=1)]
            [System.IO.FileInfo]$DestinationPath,
            [System.IO.FileInfo]$LogPath,
            [int]$FileSize,
            [switch]$Recurse,
            [switch]$Confirm
        )
        
        function Get-Files {
            [CmdletBinding()]
            param(
                [Parameter()]
                [string]$Path
            )
        
            $script:Files = Get-ChildItem -Path $Path -Recurse:$Recurse | Where-Object {
                $_.Name -like '*.mp4'`
                -or $_.Name -like '*.avi'`
                -or $_.Name -like '*.mkv'`
                -or $_.Name -like '*.wmv'`
                -or $_.Name -like '*.flv'`
                -or $_.Name -like '*.mov'`
                -and $_.Name -notlike '*1pon*'`
                -and $_.Name -notlike '*carib*' `
                -and $_.Name -notlike '*t28*'`
                -and $_.Name -notlike '*fc2*'`
                -and $_.Name -notlike '*COS☆ぱこ*'`
                -and $_.Length -ge ($FileSize * 1MB)`
            }
        }
    
        function Show-FileChanges {
            # Display file changes to host
            <#-Property @{Expression = {$_.R}; Ascending = $true}#>
            $Table = @{Expression={$_.R}; Label="R"; Width=1},
                     @{Expression={$_.M}; Label="M"; Width=1},
                     @{Expression={$_.NewName}; Label="New Name"; Width=15},
                     @{Expression={$_.Name}; Label="Orig Name"; Width=20},
                     @{Expression={$_.Size}; Label="Size"; Width=8},
                     @{Expression={$_.Path}; Label="Directory"}
            $FileObject | Sort-Object  R, M, NewName | Format-Table -Property $Table | Out-Host
        }
    
        function Move-Files {
            if ($DestinationPath) {
                $MovedFiles = @()
                if (!(Test-Path -LiteralPath $DestinationPath)) {
                    New-Item -ItemType Directory -Path $DestinationPath -Force
                }
    
                foreach ($File in $FileObject) {
                    if ($File.Path -notlike $DestinationPath) {
                        $MovedFiles += Join-Path -Path $File.Path -ChildPath $File.NewName
                    }
                }
                $MovedFiles | Move-Item -Destination $DestinationPath -Verbose
            }
        }
    
        function Remove-CompressedJAV {
            # Remove compressed -5 versions of video which is included in torrent downloads
            if ($DestinationPath) {
                Get-Files -Path $DestinationPath
            }
            else {
                Get-Files -Path $FilePath
            }

            $DuplicateFiles = $Files | Where-Object {$_.Name -like '*-5.*'}
        
            if ($DuplicateFiles) {
                Write-Output "Duplicate compressed files (files contain '-5') detected. Do you want to delete them?"
                $Input = Read-Host -Prompt '[Y] Yes    [N] No    (default is "N")'
                if ($Input -like 'y') {
                    foreach ($Duplicate in $DuplicateFiles) {
                        # If original version detected (without '-5')
                        if ($Files.Name.Contains($Duplicate.Name.Replace('-5.','.')) -and (!($Files.Name.Contains($Duplicate.Name.Replace('-5.','-4.'))))) {
                            if ($DestinationPath) {
                                Remove-Item -LiteralPath (Join-Path -Path $DestinationPath -ChildPath $Duplicate) -Verbose
                            }
                            else {
                                Remove-Item -LiteralPath (Join-Path -Path $FilePath -ChildPath $Duplicate) -Verbose
                            }
                        }
                    }
                }
            }
        }

        function Get-Timestamp {
            return "[{0:MM/dd/yy} {0:HH:mm:ss}]" -f (Get-Date)
        }
    
        # Unwanted strings in files to remove
        $RemoveStrings = @(
            # Prefixes
            'hjd2048.com-',
            '^[0-9]{4}',
            'xhd1080.com',
            'ShareSex.net',
            'jav365.com_',
            '069-3XPLANET-',
            'javl.in_',
            'Watch18plus-',
            '\[(.*?)\]',
            'FHD-',
            'FHD_',
            'fhd',
            'Watch ',
            # Suffixes (obsolete(?))
            '-h264',
            '-AV',
            '_www.avcens.download'
            '_JAV.1399.net',
            '_JAV-Video.net',
            '-VIDEOAV.NET',
            '-JAVTEG.NET',
            '.hevc.',
            '.javaddiction'
            'SmallJAV',
            ' AVFUL.TK',
            ' INCESTING.TK',
            'javnasty.tk',
            ' javhd21.com',
            ' avfullhd.tk',
            '.1080p',
            '.720p',
            '.480p',
            '-HD',
            'wmv',
            '.wmv',
            'avi',
            '.avi',
            'mp4',
            '.mp4',
            '_'
        )
    
        Get-Files -Path $FilePath
    
        $FileNameOriginal = @($Files.Name)
        $FileBaseNameOriginal = @($Files.BaseName)
        $FileExtension = @($Files.Extension)
        $FileDirectory = @($Files.FullName)
        $FileBaseNameUpper = @()
        $FileBaseNameUpperCleaned = @()
        $FinalFileName = @()
        $FileObject = @()
        $FileChangeCheck = @()
        $FileMoveCheck = @()
        $FileBaseNameHyphen = $null
        $FileP1, $FileP2, $FileP3, $FileP4 = @()
    
        if ($LogPath) {
            Start-Transcript -Path $LogPath -Append -NoClobber -IncludeInvocationHeader
        }

        # Iterate through each value in $RemoveStrings and replace from $FileBaseNameOriginal
        foreach ($String in $RemoveStrings) {
            if ($String -eq '_') {
                $FileBaseNameOriginal = $FileBaseNameOriginal -replace $String,'-'
            }
            else {
                $FileBaseNameOriginal = $FileBaseNameOriginal -replace $String,''
            }
        }
    
        foreach ($File in $FileBaseNameOriginal) {
            $FileBaseNameUpper += $File.ToUpper()
        }
    
        # Iterate through each file in $Files to add hypen(-) between title and ID if not exists
        $Counter = -1
        foreach ($File in $FileBaseNameUpper) {
            # Iterate through file name length
            for ($x = 0; $x -lt $File.Length; $x++) {
                # Match if an alphabetical character index is next to a numerical index
                if ($File[$x] -match '^[a-z]*$' -and $File[$x+1] -match '^[0-9]$') {
                    # Write modified filename to $FileBaseNameHyphen, inserting a '-' at the specified
                    # index between the alphabetical and numerical character, and appending extension
                    $FileBaseNameHyphen = ($File.Insert($x+1,'-'))
                }
            }
            # Get index if file changed
            $Counter++
            # Rename changed files
            if ($null -ne $FileBaseNameHyphen) {
                $FileBaseNameUpper[$Counter] = $FileBaseNameHyphen
            }
            $FileBaseNameHyphen = $null
        }
        
        # Clean any trailing text if not removed by $RemoveStrings
        for ($x = 0; $x -lt $FileBaseNameUpper.Length; $x++) {
            #Match ID-###A, ID###B, etc.
            if ($FileBaseNameUpper[$x] -match "[-][0-9]{1,6}[a-zA-Z]") {
                $FileP1, $FileP2, $FileP3 = $FileBaseNameUpper[$x] -split "([-][0-9]{1,6}[a-zA-Z])"
                $FileBaseNameUpperCleaned += $FileP1 + $FileP2
            }
            #Match ID-###-A, ID-###-B, etc.
            elseif ($FileBaseNameUpper[$x] -match "[-][0-9]{1,6}[-][a-zA-Z]") {
                $FileP1, $FileP2, $FileP3, $FileP4 = $FileBaseNameUpper[$x] -split "([-][0-9]{1,6})[-]([a-zA-Z])"
                $FileBaseNameUpperCleaned += $FileP1 + $FileP2 + $FileP3
            }
            # Match ID-###-1, ID-###-2, etc.
            elseif ($FileBaseNameUpper[$x] -match "[-][0-9]{1,6}[-]\d$") {
                $FileP1, $FileP2, $FileP3 = $FileBaseNameUpper[$x] -split "([-][0-9]{1,6}[-]\d)"
                $FileBaseNameUpperCleaned += $FileP1 + $FileP2
            }
            # Match ID-###-01, ID-###-02, etc.
            elseif ($FileBaseNameUpper[$x] -match "[-][0-9]{1,6}[-]\d\d$") {
                $FileP1, $FileP2, $FileP3 = $FileBaseNameUpper[$x] -split "([-][0-9]{1,6}[-]\d\d)"
                $FileBaseNameUpperCleaned += $FileP1 + $FileP2
            }
            # Match ID-###-001, ID-###-02, etc.
            elseif ($FileBaseNameUpper[$x] -match "[-][0-9]{1,6}[-]\d\d\d$") {
                $FileP1, $FileP2, $FileP3 = $FileBaseNameUpper[$x] -split "([-][0-9]{1,6}[-]\d\d\d)"
                $FileBaseNameUpperCleaned += $FileP1 + $FileP2
            }
            # Match everything else
            else {
                $FileP1, $FileP2, $FileP3 = $FileBaseNameUpper[$x] -split "([-][0-9]{1,6})"
                $FileBaseNameUpperCleaned += $FileP1 + $FileP2
            }
        }
    
        # Set final file names into array $FinalFileName
        for ($x = 0; $x -lt $FileBaseNameUpperCleaned.Length; $x++) {
            $FinalFileName += $FileBaseNameUpperCleaned[$x] + $FileExtension[$x]
        }
    
        # Add check if file needs to be changed
        for ($x = 0; $x -lt $FinalFileName.Length; $x++) {
            if ($FinalFileName[$x] -cnotlike $FileNameOriginal[$x]) {
                $FileChangeCheck += '-'
            }
            else {
                $FileChangeCheck += ''
            }
        }
    
        if ($DestinationPath) {
            for ($x = 0; $x -lt $Files.Length; $x++) {
                if ($Files.Directory[$x] -notlike $DestinationPath) {
                    $FileMoveCheck += '-'
                }
                else {
                    $FileMoveCheck += ''
                }
            }
        }
    
        # Create custom object to show file changes
        for ($x = 0; $x -lt $Files.Length; $x++) {
            $FileObject += New-Object -TypeName psobject -Property @{
                R = $FileChangeCheck[$x]
                M = $FileMoveCheck[$x]
                NewName = $FinalFileName[$x]
                Name = $Files[$x].Name
                Path = $Files[$x].Directory
                # Display in GB
                Size = [string]::Format("{0:0.00} GB", $Files[$x].Length / 1GB)
            }
        }
    
        Show-FileChanges
        
        # Exit if no changes
        if ($FileObject.R -notcontains '-' -and $FileObject.M -notcontains '-') {
            Write-Warning 'No move/rename changes, exiting...'
            Remove-CompressedJAV
            if ($LogPath) {
                Stop-Transcript
            }
            pause
            return
        }
    
        # Rename files marked with "-"
        if ($Confirm -eq $true) {
            for ($x = 0; $x -lt $Files.Length; $x++) {
                if ($FinalFileName[$x] -cnotlike $FileNameOriginal[$x]) {
                    Rename-Item -LiteralPath $FileDirectory[$x] -NewName $FinalFileName[$x] -Verbose
                }
            }
            Move-Files
            Remove-CompressedJAV
        }
    
        else {
            Write-Output 'Confirm changes?'
            if ($DestinationPath) {
                Write-Warning "Marked files will be renamed and moved to: $DestinationPath"
            }
            else {
                Write-Warning 'Marked files will be renamed'
            }

            $Input = Read-Host -Prompt '[Y] Yes    [N] No    (default is "N")'
            if ($Input -like 'y') {
                for ($x = 0; $x -lt $Files.Length; $x++) {
                    # Rename with new name
                    if ($FinalFileName[$x] -cnotlike $FileNameOriginal[$x]) {
                        Rename-Item -LiteralPath $FileDirectory[$x] -NewName $FinalFileName[$x] -Verbose
                    }
                }
                Move-Files
                Remove-CompressedJAV
            }
            else {
               Write-Warning "Cancelled by user input"
            }
        }
        if ($LogPath) {
            Stop-Transcript
        }
        pause
    }
