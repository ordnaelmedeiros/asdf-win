class AsdfStatics {

    static [string]$HOME
    static [string]$ASDF_HOME
    static [string]$ASDF_HOME_INSTALLS
    static [string]$ASDF_HOME_PLUGINS
    static [string]$ASDF_HOME_LOCAL_REPO

}

class AsdfUtils {

    static [void] trace([string]$msg) {
        Write-Information $msg -InformationAction Continue
    }

}

class AsdfPluginManager {

    [AsdfPlugin[]] all() {
        return $this.pluginByPath([AsdfStatics]::ASDF_HOME_LOCAL_REPO)
    }

    [AsdfPlugin[]] installed() {
        return $this.pluginByPath([AsdfStatics]::ASDF_HOME_PLUGINS)
    }

    [void] add($name) {
        if (!$name) {
            Write-Warning "Plugin is required"
            return 
        }
        $plugin = $this.installed() | Where-Object { $_.name -eq $name }
        if ($plugin) {
            Write-Warning "Plugin already installed"
            return
        }
        $plugin = $this.all() | Where-Object { $_.name -eq $name }
        if (!$plugin) {
            Write-Warning "Plugin not found"
            return
        }
        $plugin.add()
    }

    [void] remove($name) {
        if (!$name) {
            Write-Warning "Plugin is required"
            return 
        }
        $plugin = $this.installed() | Where-Object { $_.name -eq $name }
        if (!$plugin) {
            Write-Warning "Plugin not installed"
            return
        }
        $plugin = $this.all() | Where-Object { $_.name -eq $name }
        if (!$plugin) {
            Write-Warning "Plugin not found"
            return
        }
        $plugin.remove()
    }

    [void] updateAll() {
        foreach($p in $this.installed()) {
            $this.update($p.name)
        }
    }

    [void] update($name) {
        $this.remove($name)
        $this.add($name)
    }

    [AsdfPlugin[]] pluginByPath([string]$path) {
        $list = @()
        if (Test-Path $path) {
            foreach($i in Get-Item $path\*) {
                $list += [AsdfPlugin]::new($i.Name)
            }
        }
        return $list
    }

}

class AsdfPlugin {

    [string]$name

    AsdfPlugin([string]$name) {
        $this.name = $name
    }

    [void] add() {
        $origem = "$([AsdfStatics]::ASDF_HOME_LOCAL_REPO)\$($this.name)"
        $dest = "$([AsdfStatics]::ASDF_HOME_PLUGINS)\$($this.name)"
        New-Item -ItemType Directory -Path "$dest"
        Copy-Item -Recurse -Path "$origem\*" -Destination "$dest"
        [AsdfUtils]::trace("Plugin $($this.name) installed")
    }

    [void] remove() {
        $dest = "$([AsdfStatics]::ASDF_HOME_PLUGINS)\$($this.name)"
        Remove-Item -Recurse -Path "$dest"
        [AsdfUtils]::trace("Plugin $($this.name) removed")
    }

    [AsdfVersion[]] installed() {
        $list = @()
        $path = "$([AsdfStatics]::ASDF_HOME_INSTALLS)\$($this.name)\*" 
        if (Test-Path $path) {
            foreach($i in Get-Item $path) {
                $list += [AsdfVersion]::new($this, $i.Name)
            }
        }
        return $list
    }

    [AsdfVersion[]] all() {
        $list = @()
        foreach($i in (Get-Content "$([AsdfStatics]::ASDF_HOME_PLUGINS)\$($this.name)\versions.json" | ConvertFrom-Json)) {
            $list += [AsdfVersion]::new($this, $i.Name)
        }
        return $list
    }

    [AsdfVersion] current() {
        $version = [AsdfVersion]::new($this, "_______")
        $content = Get-Content "$([AsdfStatics]::HOME)\.win-tool-versions"
            | Select-String -Pattern "^$($this.name) "
            | Out-String
        $content = $content.Trim()
        if ($content) {
            $version.name = $content.split(" ")[1]
            $version.path = "$([AsdfStatics]::HOME)\.win-tool-versions"
        }
        $versionspath = ""
        $array = $PWD.ToString().split("\")
        foreach ( $i in $array ) {
            $versionspath += $i + "\"
            if (Test-Path "$versionspath.win-tool-versions") {
                $content = Get-Content "$versionspath.win-tool-versions"
                    | Select-String -Pattern "^$($this.name) "
                    | Out-String
                $content = $content.Trim()
                if ($content) {
                    $version.name = $content.split(" ")[1]
                    $version.path = "$versionspath.win-tool-versions"
                }
            }
        }
        return $version
    }

}

class AsdfVersion {

    [AsdfPlugin]$plugin
    [string]$name
    [string]$path

    AsdfVersion([AsdfPlugin]$plugin, [string]$name) {
        $this.plugin = $plugin
        $this.name = $name
        $this.path = "No version is set. Run 'asdf <global|shell|local> $($plugin.name) <version>'"
    }

}
