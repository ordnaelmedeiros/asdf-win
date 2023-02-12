# asdf list <name> [version]              List installed versions of a package and
#                                         optionally filter the versions
# asdf list all <name> [<version>]        List all versions of a package and
#                                         optionally filter the returned versions

if ($name1 -eq "all") {
    if ($name2) {
        if (Test-Path "$ASDF_HOME_PLUGINS\$name2") {
            (Get-Content "$ASDF_HOME_PLUGINS\$name2\versions.json" | ConvertFrom-Json).name
        }
    } else {
        Write-Warning "name is required"
    }
} elseif ($name1) {
    if (Test-Path "$ASDF_HOME_INSTALLS\$name1") {
        (Get-Item "$ASDF_HOME_INSTALLS\$name1\*").Name
    }
} else {
    foreach ($i in (Get-Item "$ASDF_HOME_INSTALLS\*").Name) {
        Write-Output "$i"
        foreach ($j in (Get-Item "$ASDF_HOME_INSTALLS\$i\*").Name) {
            Write-Output "  $j"
        }
    }
}
