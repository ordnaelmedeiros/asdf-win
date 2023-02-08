if (!(test-path $PROFILE.CurrentUserAllHosts)) {
    $array = $PROFILE.CurrentUserAllHosts.split("\")
    $array = $array[0..($array.Length-2)]
    $path = $array -join "\"
    mkdir -p $path
    Write-Output "" >> $PROFILE.CurrentUserAllHosts
}

$content = Get-Content $PROFILE.CurrentUserAllHosts
    | Select-String -Pattern "asdf" -NotMatch
    | Select-String -Pattern "\S"
    
Set-Content -Path $PROFILE.CurrentUserAllHosts -Value $content
Write-Output "" >> $PROFILE.CurrentUserAllHosts
Write-Output ". '${HOME}\.asdf\asdf.ps1'" >> $PROFILE.CurrentUserAllHosts

."${HOME}\.asdf\asdf.ps1"
