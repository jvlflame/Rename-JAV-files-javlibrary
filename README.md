# Rename JAV Files
Rename JAV files downloaded from JAVLibrary.com
![Demo](https://github.com/jvlflame/Rename-JAV-files/blob/master/demo.gif?raw=true)

## Usage
Clone the repository. Load Rename-Jav.ps1 from a **non-admin** PowerShell prompt.

### Examples
**Example 1** Rename all files recursively in path C:\Downloads\ with filesize greater than 500MB and move all found video files to C:\Downloads\SortedFiles\. Write log to C:\Downloads\RenameLog.txt
`Rename-JAV -FilePath 'C:\Downloads\' -DestinationPath 'C:\Downloads\SortedFiles\ -LogPath 'C:\Downloads\RenameLog.txt' -FileSize 500 -Recurse`

**Example 2** Rename only files located in path C:\Downloads\ with filesize greater than 400MB
`Rename-JAV -FilePath 'C:\Downloads\' -FileSize 400`

**Example 3** Rename all files recursively in path C:\Downloads\ with filesize greater than 0MB and write log to C:\Downloads\RenameLog.txt without prompting Yes/No
`Rename-JAV -FilePath 'C:\Downloads\' -LogPath 'C:\Downloads\RenameLog.txt' -Recurse -Confirm`


