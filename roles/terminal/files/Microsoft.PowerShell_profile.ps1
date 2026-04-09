if (Get-Module -ListAvailable -Name PSReadLine) {
    Import-Module PSReadLine
    $esc = [char]27
    $fg = "$esc[39m"
    Set-PSReadLineOption -Colors @{
        Default = $fg
        Number  = $fg
    }
}
