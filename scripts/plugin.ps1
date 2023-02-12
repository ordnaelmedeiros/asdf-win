# MANAGE PLUGINS
# asdf plugin add <name> [<git-url>]      Add a plugin from the plugin repo OR,
#                                         add a Git repo as a plugin by
#                                         specifying the name and repo url
# asdf plugin list [--urls] [--refs]      List installed plugins. Optionally show
#                                         git urls and git-ref
# asdf plugin list all                    List plugins registered on asdf-plugins
#                                         repository with URLs
# asdf plugin remove <name>               Remove plugin and package versions
# asdf plugin update <name> [<git-ref>]   Update a plugin to latest commit on
#                                         default branch or a particular git-ref
# asdf plugin update --all                Update all plugins to latest commit on
#                                         default branch

# echo "plugincmd: $plugin"
# echo "plugin: $plugin"

if ($plugin -eq "add") {
    if ($plugin -and $PLUGINS_NAMES.contains($name)) {
        if (!(Test-Path "$ASDF_HOME_PLUGINS\$name")) {
            New-Item -ItemType Directory -Path "$ASDF_HOME_PLUGINS\$name"
            Copy-Item -Recurse -Path "$ASDF_HOME_LOCAL_REPO\$name\*" -Destination "$ASDF_HOME_PLUGINS\$name"
            Write-Output "Plugin installed"
            Write-Warning "Restart PowerShell"
        } else {
            Write-Output "Plugin already installed"
        }
    } else {
        Write-Output "Plugin is required"
    }
} elseif ($plugin -eq "list") {
    if ($name -eq "all") {
        $PLUGINS_NAMES
    } else {
        if (Test-Path $ASDF_HOME_PLUGINS) {
            (Get-Item $ASDF_HOME_PLUGINS\*).Name
        }
    }
} elseif ($plugin -eq "remove") {
    if ($name) {
        if (Test-Path "$ASDF_HOME_PLUGINS\$name") {
            if (Test-Path "$ASDF_HOME_INSTALLS\$name") {
                Remove-Item -Recurse -Path "$ASDF_HOME_INSTALLS\$name"
            }
            Remove-Item -Recurse -Path "$ASDF_HOME_PLUGINS\$name"
            Write-Output "Plugin removed"
            Write-Warning "Restart PowerShell"
        } else {
            Write-Output "Plugin not found"
        }
    } else {
        Write-Output "Plugin is required"
    }
} elseif ($plugin -eq "update") {
    if ($name) {
        if (Test-Path "$ASDF_HOME_PLUGINS\$name") {
            Remove-Item -Recurse -Path "$ASDF_HOME_PLUGINS\$name"
            New-Item -ItemType Directory -Path "$ASDF_HOME_PLUGINS\$name"
            Copy-Item -Recurse -Path "$ASDF_HOME_LOCAL_REPO\$name\*" -Destination "$ASDF_HOME_PLUGINS\$name"
        } else {
            Write-Output "Plugin not found"
        }
    } elseif ($all) {
        foreach($i in (Get-Item "$ASDF_HOME_PLUGINS\*").Name) {
            asdf plugin update $i
        }
    } else {
        Write-Output "Plugin is required"
    }
}
