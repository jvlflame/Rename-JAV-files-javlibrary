# Rename JAV Files
Rename JAV files downloaded from JAVLibrary.com to their common ID format.

## About
Rename-JAV.ps1 will:

* Rename JAV files to their ID format from files directly downloaded and torrented from JAVLibrary.com
* Move all files to a specified directory if desired
* Remove compressed '-5' format videos if the original exists

The script does not perform any webscraping or metadata checks. This is simply renaming through Regex checks, so make sure to confirm that all the files are being renamed correctly before confirming. If files are not being found, make necessary adjustments to the Get-Files function.

## How to use?
Clone the repository to a desired location. Run Rename-Jav.ps1 from a **non-administrator** PowerShell prompt. You may not be able to find network drives when running PowerShell as administrator. I recommend creating specified directories for downloading/sorting and then converting the script to an .exe with a [PS2EXE Converter](https://gallery.technet.microsoft.com/scriptcenter/PS2EXE-GUI-Convert-e7cb69d5).

### Parameters
**.PARAMETER** FilePath [Required]

  Specifies the path to video files.

**.PARAMETER** DestinationPath

  Specifies the path to move all video files to.

**.PARAMETER** LogPath

  Specifies the path and filename of the log file. Recommended to keep track of file changes.

**.PARAMETER** FileSize

  Specifies the minimum filesize of video files to search in Megabytes (MB).

**.PARAMETER** Recurse

  Specifies to run a recursive search of the FilePath directory.

**.PARAMETER** Confirm

  Specifies to skip the yes/no prompt before renaming/moving the video files.

## Examples
**Example 1** Rename all files recursively in path C:\Downloads\ with filesize greater than 500MB and move all found video files to C:\Downloads\SortedFiles\. Write log to C:\Downloads\RenameLog.txt.

`Rename-JAV -FilePath 'C:\Downloads\' -DestinationPath 'C:\Downloads\SortedFiles\ -LogPath 'C:\Downloads\RenameLog.txt' -FileSize 500 -Recurse`

**Example 2** Rename only files located in path C:\Downloads\ with filesize greater than 400MB.

`Rename-JAV -FilePath 'C:\Downloads\' -FileSize 400`

**Example 3** Rename all files recursively in path C:\Downloads\ with filesize greater than 0MB without prompting yes/no. write log to C:\Downloads\RenameLog.txt.

`Rename-JAV -FilePath 'C:\Downloads\' -LogPath 'C:\Downloads\RenameLog.txt' -Recurse -Confirm`

## Demo
![Demo](https://github.com/jvlflame/Rename-JAV-files/blob/master/demo.gif?raw=true)

The R/M column indicate if the file will be Renamed/Moved respectively.

## Known issues
I recommend not to use this script recursively within a very large directory. I would say up to 50 files at a time, but if all looks good, go for more. If you have downloaded files from alternative sources, you may run into issues where it breaks the script. Remove all conflicting files before running again.
