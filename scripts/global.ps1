# asdf global <name> <version>            Set the package global version
# asdf global <name> latest[:<version>]   Set the package global version to the
#                                         latest provided version

# echo "$name - $version"

if ($name -and $version) {

    if (Test-Path "$ASDF_HOME_INSTALLS\$name\$version") {

        $path = "$HOME\.win-tool-versions"
        
        if (!(Test-Path $path)) {
            Write-Output "" >> $path
        }
        
        $content = Get-Content $path
            | Select-String -Pattern "$name" -NotMatch
            | Select-String -Pattern "\S"
        
        Set-Content -Path $path -Value $content

        $global = $true
        asdf env $name $version
        
        Write-Output "${name} ${version}" >> $path

    } else {
        Write-Warning "$name - $version not instaled"
    }


} else {
    Write-Warning "plugin and version required"
}
