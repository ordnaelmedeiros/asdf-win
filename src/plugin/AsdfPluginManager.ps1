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
