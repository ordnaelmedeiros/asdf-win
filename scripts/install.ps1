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
            $config = Get-Content "$ASDF_HOME_PLUGINS\$name\config.json" | ConvertFrom-Json
            $configFileType = $config.fileType
            $configFolderPath = $config.folderPath
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

            if ($configFileType -eq "folder") {
                if ($url.EndsWith(".zip")) {
                    Expand-Archive -LiteralPath "$path_download\file" -DestinationPath $path_install_tmp
                    Copy-Item -Recurse -Path ${path_install_tmp}${configFolderPath}* -Destination "$path_install"
                } elseif ($url.EndsWith(".tar.gz")) {
                    tar -xvzf "$path_download\file" -C $path_install_tmp
                    Copy-Item -Recurse -Path ${path_install_tmp}${configFolderPath}* -Destination "$path_install"
                }
            } else {
                Copy-Item -Path "$path_download\file" -Destination "$path_install\file.${configFileType}"
            }
            if (Test-Path "$ASDF_HOME_PLUGINS\$name\install.ps1") {
                ."$ASDF_HOME_PLUGINS\$name\install.ps1"
            }
            Remove-Item -Recurse -Path $path_install_tmp
            Write-Output "$name - $version installed"

        } else {
            Write-Warning "$name - $version not found"
        }

    }

} elseif ($name) {
    if (Test-Path "$PWD\.win-tool-versions") {
        Get-Content "$PWD\.win-tool-versions"
            | Select-String -Pattern "^$name "
            | ForEach-Object {
                $pluginarray = $_.ToString().split(" ")
                $p = $pluginarray[0]
                $l = $pluginarray[1]
                asdf plugin add $p
                asdf install $p $l
            }
    } else {
        Write-Warning "local config not found"
    }
} else {
    if (Test-Path "$PWD\.win-tool-versions") {
        Get-Content "$PWD\.win-tool-versions" |
            ForEach-Object {
                $pluginarray = $_.split(" ")
                $p = $pluginarray[0]
                $l = $pluginarray[1]
                asdf plugin add $p
                asdf install $p $l
            }
    } else {
        Write-Warning "local config not found"
    }
}
