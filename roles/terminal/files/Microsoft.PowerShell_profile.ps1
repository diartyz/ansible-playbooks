if (Get-Module -ListAvailable -Name PSReadLine) {
    Import-Module PSReadLine
    $esc = [char]27
    Set-PSReadLineOption -Colors @{ Default = "$esc[39m" }
}
