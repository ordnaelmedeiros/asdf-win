# asdf plugin add <name>
# asdf plugin list
# asdf plugin list all
# asdf plugin remove <name>
# asdf plugin update <name>
# asdf plugin update --all

# echo "plugincmd: $plugincmd"
# echo "plugin: $plugin"

if ($plugincmd -eq "add") {
    if ($plugin -and $PLUGINS_NAMES.contains($plugin)) {
        if (!(Test-Path "$ASDF_HOME_PLUGINS\$plugin")) {
            New-Item -ItemType Directory -Path "$ASDF_HOME_PLUGINS\$plugin"
            Copy-Item -Recurse -Path "$ASDF_HOME_LOCAL_REPO\$plugin\*" -Destination "$ASDF_HOME_PLUGINS\$plugin"
            Write-Output "plugin installed"
        } else {
            Write-Output "plugin already installed"
        }
    } else {
        Write-Output "plugin is required"
    }
} elseif ($plugincmd -eq "list") {
    if ($plugin -eq "all") {
        $PLUGINS_NAMES
    } else {
        if (Test-Path $ASDF_HOME_PLUGINS) {
            (Get-Item $ASDF_HOME_PLUGINS\*).Name
        }
    }
} elseif ($plugincmd -eq "remove") {
    if ($plugin) {
        if (Test-Path "$ASDF_HOME_PLUGINS\$plugin") {
            if (Test-Path "$ASDF_HOME_INSTALLS\$plugin") {
                Remove-Item -Recurse -Path "$ASDF_HOME_INSTALLS\$plugin"
            }
            Remove-Item -Recurse -Path "$ASDF_HOME_PLUGINS\$plugin"
            Write-Output "plugin removed"
        } else {
            Write-Output "plugin not found"
        }
    } else {
        Write-Output "plugin is required"
    }
} elseif ($plugincmd -eq "update") {
    if ($plugin) {
        if (Test-Path "$ASDF_HOME_PLUGINS\$plugin") {
            Remove-Item -Recurse -Path "$ASDF_HOME_PLUGINS\$plugin"
            New-Item -ItemType Directory -Path "$ASDF_HOME_PLUGINS\$plugin"
            Copy-Item -Recurse -Path "$ASDF_HOME_LOCAL_REPO\$plugin\*" -Destination "$ASDF_HOME_PLUGINS\$plugin"
        } else {
            Write-Output "plugin not found"
        }
    } else {
        Write-Output "plugin is required"
    }
}
