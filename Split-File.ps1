
Function Split-File
{
    PARAM(
        [string]$Path,
        [int64]$Lines,
        [int64]$Size,
        [string]$Encoding = 'UTF8'
    )

    $Path_ = Get-Item -Path $Path

    switch($Encoding){
        'Default' {$Encoding_ = [System.Text.Encoding]::Default}
        'ANSI' {$Encoding_ = [System.Text.Encoding]::ANSI}
        'BigEndianUnicode' {$Encoding_ = [System.Text.Encoding]::BigEndianUnicode}
        'Unicode' {$Encoding_ = [System.Text.Encoding]::Unicode}
        'UTF32' {$Encoding_ = [System.Text.Encoding]::UTF32}
        'UTF7' {$Encoding_ = [System.Text.Encoding]::UTF7}
        'UTF8' {$Encoding_ = [System.Text.Encoding]::UTF8}
    }

    if($Lines)
    {
        $Reader = New-Object System.IO.StreamReader($Path_.FullName, $Encoding_)
        $FileIndex = 0
        while(!$Reader.EndOfStream)
        {
            $i = 0
            $FileName = '{0}\{1}.{2}{3}' -f $Path_.DirectoryName, $Path_.BaseName, $FileIndex, $Path_.Extension
            Write-Output $FileName
            $Writer = New-Object System.IO.StreamWriter($FileName, $Encoding_)
            while($i -lt $Lines -and !$Reader.EndOfStream)
            {
                $i++
                $Writer.WriteLine($Reader.ReadLine())
            }
            $Writer.Close()
            $FileIndex++
        }
        $Reader.Close()
    }

    if($Size)
    {
        $Reader = [System.IO.File]::OpenRead($Path_.FullName)
        $Buffer = New-Object byte[] $Size
        $FileIndex = 0
        $EstimateNumberOfFiles = [math]::Ceiling((Get-Item -Path $Path).Length/$Size)
        $NumberSize = 1
        while(($EstimateNumberOfFiles/[math]::Pow(10, $NumberSize)) -ge 1){$NumberSize++}
        while($Reader.Position -lt $Reader.Length)
        {
            $FileName = "{0}\{1}{3}.{2:D$NumberSize}" -f $Path_.DirectoryName, $Path_.BaseName, $FileIndex, $Path_.Extension
            Write-Output $FileName
            $Writer = [System.IO.File]::OpenWrite($FileName)
            $Writer.Write($Buffer, 0, $Reader.Read($Buffer, 0, $Buffer.Length))
            $Writer.Close()
            $FileIndex++
        }
        $Reader.Close()
        Remove-Variable -Name "Buffer"
        [gc]::Collect()
    }
}

function Join-File
{
    PARAM(
        [string]$Path
    )
    $file = Get-Item -Path $Path
    if($file.Name -match "^(.+?)\.(0+)$")
    {
        $PartialFileName = $Matches[1]
        $SequenceLength = $Matches[2].Length
        Write-Host "Looking for range: $PartialFileName.$('0' * $SequenceLength) --> $PartialFileName.$('9' * $SequenceLength)"
        $files = @()
        for($i = 0; $i -le ([math]::Pow(10, $SequenceLength) - 1); $i++)
        {
            $File_ = Join-Path -Path $file.DirectoryName -ChildPath "$PartialFileName.$("{0:D$SequenceLength}" -f $i)"
            Write-Host "Checking: '$File_' --- " -NoNewline
            if(Test-Path -Path $File_)
            {
                Write-Host "Found" -ForegroundColor Green
                $files += Get-Item -Path $File_
            }
            else
            {
                Write-Host "End" -ForegroundColor Yellow
                break
            }
        }
        $totalsize = 0
        $files | %{
            # Write-Host "Going to combine: $($_.FullName); Size: $($_.Length) bytes"
            $totalsize += $_.Length
        }
        Write-Host "Total size: $totalsize bytes"
        $output = Join-Path -Path $file.DirectoryName -ChildPath "$PartialFileName.Joined"
        Write-Host "Output: $output"
        if(Test-Path -Path $output)
        {
            throw "Path already exists: $output"
        }
        else
        {
            $fs = New-Object System.IO.FileStream @($output, [System.IO.FileMode]::Append, [System.IO.FileAccess]::Write)
            $w = New-Object System.IO.BinaryWriter($fs)
            $files | %{
                $w.Write([io.file]::ReadAllBytes($_.FullName))
            }
            $w.Close()
            $fs.Close()
        }
        Write-Host "Completed!"
    }
    else
    {
        throw "Please privide the first file, which end with .0 or .000, similar"
    }
}
