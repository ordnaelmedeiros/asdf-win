if (!(test-path $PROFILE.CurrentUserAllHosts)) {
    $array = $PROFILE.CurrentUserAllHosts.split("\")
    $array = $array[0..($array.Length-2)]
    $path = $array -join "\"
    mkdir -p $path
    echo "" >> $PROFILE.CurrentUserAllHosts
}

$content = Get-Content $PROFILE.CurrentUserAllHosts
    | Select-String -Pattern "asdf" -NotMatch
    | Select-String -Pattern "\S"
    
Set-Content -Path $PROFILE.CurrentUserAllHosts -Value $content
echo "" >> $PROFILE.CurrentUserAllHosts
echo ". '${HOME}\.asdf\asdf.ps1'" >> $PROFILE.CurrentUserAllHosts

."${HOME}\.asdf\asdf.ps1"
