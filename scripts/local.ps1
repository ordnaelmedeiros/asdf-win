# asdf local <name> <version>             Set the package local version
# asdf local <name> latest[:<version>]    Set the package local version to the
#                                         latest provided version

# echo "$name - $version"

if ($name -and $version) {

    if (Test-Path "$ASDF_HOME_INSTALLS\$name\$version") {

        $path = "$PWD\.win-tool-versions"
        
        if (!(Test-Path $path)) {
            Write-Output "" >> $path
        }
        
        $content = Get-Content $path
            | Select-String -Pattern "$name" -NotMatch
            | Select-String -Pattern "\S"
        
        Set-Content -Path $path -Value $content
        
        Write-Output "${name} ${version}" >> $path

    } else {
        Write-Warning "$name - $version not instaled"
    }


} else {
    Write-Warning "plugin and version required"
}
