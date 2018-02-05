
# Powershell-Split-File

## Powershell is bad at handling large file?

It's true, try run `$t = Get-Content SomeFile.large`, powershell will try load the whole file in memory and you will feel why I wrote this script.

## Make it easy.

```
PS> # Split text file by 1m lines each
PS> . .\Split-File.ps1
PS> Split-File -Path "LargeTextFile.txt" -Lines 1000000
PS>
PS> # Split file from binary, 100MB each
PS> Split-File -Path "LargeFile" -Size 100mb
```

## Encoding

`-Encoding Unicode` is applied to Text split only (binary doesn't care this obviously)

- Larry.Song@outlook.com
