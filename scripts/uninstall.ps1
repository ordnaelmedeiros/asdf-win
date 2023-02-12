# asdf install                            Install all the package versions listed
#                                         in the .tool-versions file
# asdf install <name>                     Install one tool at the version
#                                         specified in the .tool-versions file
# asdf install <name> <version>           Install a specific version of a package
# asdf install <name> latest[:<version>]  Install the latest stable version of a
#                                         package, or with optional version,
#                                         install the latest stable version that
#                                         begins with the given string

# echo "name: $name"
# echo "version: $version"

if ($name -and $version) {
    if (Test-Path "$ASDF_HOME_INSTALLS\$name\$version") {
        Remove-Item -Recurse -Path "$ASDF_HOME_INSTALLS\$name\$version"
    } else {
        Write-Warning "$name $version not installed"
    }
}
