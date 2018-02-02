
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
        while($Reader.Position -lt $Reader.Length)
        {
            $FileName = '{0}\{1}.{2}{3}' -f $Path_.DirectoryName, $Path_.BaseName, $FileIndex, $Path_.Extension
            Write-Output $FileName
            $Writer = [System.IO.File]::OpenWrite($FileName)
            $Writer.Write($Buffer, 0, $Reader.Read($Buffer, 0, $Buffer.Length))
            $Writer.Close()
            $FileIndex++
        }
        $Reader.Close()
    }
}
