# Rename JAV Files
[![GitHub release](https://img.shields.io/github/release/jvlflame/Rename-JAV-files-javlibrary.svg?label=release)](https://github.com/jvlflame/Rename-JAV-files-javlibrary/releases/)
[![GitHub downloads](https://img.shields.io/github/downloads/jvlflame/Rename-JAV-files-javlibrary/total.svg?style=popout)](#)
[![Last commit](https://img.shields.io/github/last-commit/jvlflame/Rename-JAV-files-javlibrary.svg?style=popout)](https://github.com/jvlflame/Rename-JAV-files-javlibrary/commits/master)
[![License](https://img.shields.io/github/license/jvlflame/Rename-JAV-files-javlibrary.svg?style=popout)](https://github.com/jvlflame/Rename-JAV-files-javlibrary/blob/master/LICENSE)

Rename JAV files downloaded from JAVLibrary.com to their common ID format. I find that video files direct downloaded or torrented from JavLibrary tend to be inconsistent and ugly. This script is best used if you sort your media library manually and wanted a consistent video ID naming scheme.

## Demo
![Demo](https://github.com/jvlflame/Rename-JAV-files/blob/master/demo.gif?raw=true)

The R/M column indicates if the file will be Renamed/Moved respectively.

## About
**Rename-JAV.ps1** will:

* Rename JAV files to their ID format from files directly downloaded and torrented from JAVLibrary.com
* Move all files to a specified directory if desired
* Remove compressed '-5' format videos if the original exists

*The script does not perform any webscraping or metadata checks.* This is simply renaming through Regex checks, so make sure to confirm that all the files are being renamed correctly before confirming. If files are not being found, make necessary adjustments to the Get-Files function.

**Move-JAV.ps1** will:

* Move all found video files from a specified path to another specified path
* Delete all remaining files

This is useful if you commonly download torrents which contain a lot of extra trash files.

## How to use?
Clone the repository to a desired location. Run Rename-Jav.ps1 or Move-JAV.ps1 from a **non-administrator** PowerShell prompt. You may not be able to find network drives when running PowerShell as administrator. I recommend creating specified directories for downloading/sorting and then converting the script to an .exe with a [PS2EXE Converter](https://gallery.technet.microsoft.com/scriptcenter/PS2EXE-GUI-Convert-e7cb69d5).

### Rename-JAV.ps1 Parameters
**.PARAMETER** FilePath [Required]

&nbsp;&nbsp;&nbsp;&nbsp;Specifies the path to the video files.

**.PARAMETER** DestinationPath

&nbsp;&nbsp;&nbsp;&nbsp;Specifies the path to move all video files to.

**.PARAMETER** LogPath

&nbsp;&nbsp;&nbsp;&nbsp;Specifies the path and filename of the log file. Recommended to keep track of file changes.

**.PARAMETER** FileSize

&nbsp;&nbsp;&nbsp;&nbsp;Specifies the minimum filesize of video files to search in Megabytes (MB).

**.PARAMETER** Recurse

&nbsp;&nbsp;&nbsp;&nbsp;Specifies to run a recursive search of the FilePath directory.

**.PARAMETER** Confirm

&nbsp;&nbsp;&nbsp;&nbsp;Specifies to skip the yes/no prompt before renaming/moving the video files.

### Move-JAV.ps1 Parameters
**.PARAMETER** FilePath [Required]

&nbsp;&nbsp;&nbsp;&nbsp;Specifies the path to the your torrent download directory.

**.PARAMETER** FileSize [Required]

&nbsp;&nbsp;&nbsp;&nbsp;Specifies the minimum filesize of video files to search in Megabytes (MB). I recommend at least 250.

## Examples
**Example 1** Rename all files recursively in path C:\Downloads\ with filesize greater than 500MB. Write log to C:\Downloads\RenameLog.txt.
```
Rename-JAV -FilePath 'C:\Downloads\' -LogPath 'C:\Downloads\RenameLog.txt' -FileSize 500 -Recurse
```
**Example 2** Rename only files located in path C:\Downloads\ with filesize greater than 400MB and move all found video files to C:\Downloads\SortedFiles\.
```
Rename-JAV -FilePath 'C:\Downloads\' -DestinationPath 'C:\Downloads\SortedFiles\ -FileSize 400
```

**Example 3** Rename all files recursively in path C:\Downloads\ with filesize greater than 0MB without prompting yes/no. write log to C:\Downloads\RenameLog.txt.
```
Rename-JAV -FilePath 'C:\Downloads\' -LogPath 'C:\Downloads\RenameLog.txt' -Recurse -Confirm
```

## Known issues
I recommend not to use this script recursively within a very large directory. I would say up to 50 files at a time, but if all looks good, go for more. If you have downloaded files from alternative sources, you may run into issues where it breaks the script. Press `Ctrl+C` to cancel the running script. Remove all conflicting files before running again.

## To do
- [x] Working build
- [ ] Better logging
- [ ] Better error handling
- [ ] Allow reversal of changes made
- [ ] Create GUI front-end
