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
        Write-Warning "$name $version already installed"
    } else {

        $path_download = "$ASDF_HOME_DOWNLOADS\$name\$version"
        $path_install = "$ASDF_HOME_INSTALLS\$name\$version"
        $path_install_tmp = "$ASDF_HOME_INSTALLS\$name\tmp"

        $url = 
            (
                Get-Content "$ASDF_HOME_PLUGINS\$name\versions.json"
                    | ConvertFrom-Json
                    | Where-Object { $_.name -eq $version }
            ).url

        if ($url) {
            if (Test-Path $path_download) {
                Remove-Item -Recurse -Path $path_download
            }
            New-Item -ItemType Directory -Path $path_download
            
            Invoke-WebRequest -Uri $url -OutFile "$path_download\file"
            if (Test-Path $path_install) {
                Remove-Item -Recurse -Path $path_install
            }
            if (Test-Path $path_install_tmp) {
                Remove-Item -Recurse -Path $path_install_tmp
            }
            New-Item -ItemType Directory -Path $path_install
            New-Item -ItemType Directory -Path $path_install_tmp
            if ($url.EndsWith(".zip")) {
                Expand-Archive -LiteralPath "$path_download\file" -DestinationPath $path_install_tmp
                Copy-Item -Recurse -Path ${path_install_tmp}\*\* -Destination "$path_install"
                Remove-Item -Recurse -Path $path_install_tmp
            } elseif ($url.EndsWith(".tar.gz")) {
                tar -xvzf "$path_download\file" -C $path_install_tmp
                Copy-Item -Recurse -Path ${path_install_tmp}\*\* -Destination "$path_install"
                Remove-Item -Recurse -Path $path_install_tmp
            } else {
                Copy-Item -Path "$path_download\file" -Destination "$path_install\exec"
            }

            Write-Output "$name - $version installed"

        } else {
            Write-Warning "$name - $version not found"
        }

    }

}
