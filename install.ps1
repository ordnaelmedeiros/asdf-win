if (!(test-path $PROFILE.CurrentUserAllHosts)) {
    New-Item -ItemType "file" -Path $PROFILE.CurrentUserAllHosts -Force
}

$content = Get-Content $PROFILE.CurrentUserAllHosts
    | Select-String -Pattern "asdf" -NotMatch
    | Select-String -Pattern "\S"
    
Set-Content -Path $PROFILE.CurrentUserAllHosts -Value $content
Write-Output "" >> $PROFILE.CurrentUserAllHosts
Write-Output ". '${HOME}\.asdf\launcher.ps1'" >> $PROFILE.CurrentUserAllHosts

."${HOME}\.asdf\launcher.ps1"
