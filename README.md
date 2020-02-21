
# Powershell-Split-File

## Powershell is bad at handling large file?

It's true, try run `$t = Get-Content SomeFile.large`, powershell will try load the whole file in memory and you may understand why I wrote this script.

## Make it easy.

```
PS> # Split text file by 1m lines each
PS> . .\Split-File.ps1
PS> Split-File -Path "LargeTextFile.txt" -Lines 1000000
PS>
PS> # Split file in binary, 100MB each
PS> Split-File -Path "LargeFile" -Size 100mb

PS> Split-File -Path .\sampledata.bin -Size 1
sampledata.bin.00
sampledata.bin.01
sampledata.bin.02
sampledata.bin.03
sampledata.bin.04
sampledata.bin.05
sampledata.bin.06
sampledata.bin.07
sampledata.bin.08
sampledata.bin.09
sampledata.bin.10
sampledata.bin.11
sampledata.bin.12
PS> Join-File -Path sampledata.bin.00
Looking for range: sampledata.bin.00 --> sampledata.bin.99
Checking: 'sampledata.bin.00' --- Found
Checking: 'sampledata.bin.01' --- Found
Checking: 'sampledata.bin.02' --- Found
Checking: 'sampledata.bin.03' --- Found
Checking: 'sampledata.bin.04' --- Found
Checking: 'sampledata.bin.05' --- Found
Checking: 'sampledata.bin.06' --- Found
Checking: 'sampledata.bin.07' --- Found
Checking: 'sampledata.bin.08' --- Found
Checking: 'sampledata.bin.09' --- Found
Checking: 'sampledata.bin.10' --- Found
Checking: 'sampledata.bin.11' --- Found
Checking: 'sampledata.bin.12' --- Found
Checking: 'sampledata.bin.13' --- End
Total size: 13 bytes
Output: sampledata.bin.Joined
Completed!
```

## Encoding

`-Encoding Unicode` is applied to Text split only (binary doesn't care this obviously)

- Larry.Song@outlook.com
