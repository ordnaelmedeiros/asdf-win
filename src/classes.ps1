class AsdfStatics {

    static [string]$HOME
    static [string]$ASDF_HOME
    static [string]$ASDF_HOME_INSTALLS
    static [string]$ASDF_HOME_DOWNLOADS
    static [string]$ASDF_HOME_PLUGINS
    static [string]$ASDF_HOME_LOCAL_REPO

}

class AsdfUtils {

    static [void] trace([string]$msg) {
        Write-Information $msg -InformationAction Continue
    }

    static [AsdfVersion[]] readByfile([string]$path) {

        $pluginManager = [AsdfPluginManager]::new()

        $versions = @()

        if (!$path.EndsWith("\") -and !$path.EndsWith("/")) {
            $path += "\"
        }
        $path += ".win-tool-versions"

        if (Test-Path $path) {
            foreach($line in (Get-Content "$path")) {
                $itens = $line.split(" ")
                $plugin = $pluginManager.plugin($itens[0])
                $version = [AsdfVersion]::new($plugin, $itens[1])
                $version.path = $path
                $versions += $version
            }
        }
        return $versions
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

    [AsdfPlugin] plugin([string]$name) {
        $item = $this.all() | Where-Object { $_.name -eq $name }
        if (!$item) {
            throw "Plugin ${name} not found"
        }
        return $item
    }

    [AsdfVersion[]] readByfile([string]$path) {
        return [AsdfUtils]::readByfile($path)
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
        $other = [AsdfUtils]::readByfile([AsdfStatics]::HOME) | Where-Object { $_.plugin.name -eq $this.name }
        if ($other) {
            $version.name = $other.name
            $version.path = $other.path
        }
        $versionspath = ""
        $array = $PWD.ToString().split("\")
        foreach ( $i in $array ) {
            $versionspath += $i + "\"
            $other = [AsdfUtils]::readByfile($versionspath) | Where-Object { $_.plugin.name -eq $this.name }
            if ($other) {
                $version.name = $other.name
                $version.path = $other.path
            }
        }
        return $version
    }

    [AsdfVersion] version([string]$version) {
        $item = $this.all() | Where-Object { $_.name -eq $version }
        if (!$item) {
            throw "Version $($this.name) ${version} not found"
        }
        return $item
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

    [void] configEnv() {
        $dest = "$([AsdfStatics]::ASDF_HOME_INSTALLS)\$($this.plugin.name)\$($this.name)"
        $config = (Get-Content "$([AsdfStatics]::ASDF_HOME_PLUGINS)\$($this.plugin.name)\config.json" | ConvertFrom-Json)
        [Environment]::SetEnvironmentVariable($config.envName, $dest, 'User')
    }

    [void] global() {
        $dest = "$([AsdfStatics]::HOME)\.win-tool-versions"
        if (!(Test-Path $dest)) {
            Write-Output "" >> $dest
        }
        $content = Get-Content $dest
            | Select-String -Pattern "^$($this.plugin.name) " -NotMatch
            | Select-String -Pattern "\S"
        Set-Content -Path $dest -Value $content
        Write-Output "$($this.plugin.name) $($this.name)" >> $dest
        $this.configEnv()
    }

    [void] install() {

        $path_install = "$([AsdfStatics]::ASDF_HOME_INSTALLS)\$($this.plugin.name)\$($this.name)"
        $path_install_tmp = "$([AsdfStatics]::ASDF_HOME_INSTALLS)\$($this.plugin.name)\$($this.name)-tmp"
        $path_download = "$([AsdfStatics]::ASDF_HOME_DOWNLOADS)\$($this.plugin.name)\$($this.name)"

        if (Test-Path $path_install) {
            Write-Warning "$($this.plugin.name) $($this.name) already installed"
            return
        }

        $url = $this.getUrl()
        if (!$url) {
            Write-Warning "$($this.plugin.name) $($this.name) not found"
            return
        }

        $config = Get-Content "$([AsdfStatics]::ASDF_HOME_PLUGINS)\$($this.plugin.name)\config.json" | ConvertFrom-Json

        $this.recreatePath($path_download)
        $this.recreatePath($path_install_tmp)

        Invoke-WebRequest -Resume -Uri $url -OutFile "$path_download\file"
        
        $this.recreatePath($path_install)

        if ($config.fileType -eq "folder") {
            if ($url.EndsWith(".zip")) {
                Expand-Archive -LiteralPath "$path_download\file" -DestinationPath $path_install_tmp
                Copy-Item -Recurse -Path "${path_install_tmp}$($config.folderPath)*" -Destination "$path_install"
            } elseif ($url.EndsWith(".tar.gz")) {
                tar -xvzf "$path_download\file" -C $path_install_tmp
                Copy-Item -Recurse -Path "${path_install_tmp}$($config.folderPath)*" -Destination "$path_install"
            }
        } else {
            Copy-Item -Path "$path_download\file" -Destination "$path_install\file.$($config.fileType)"
        }
        if (Test-Path "$([AsdfStatics]::ASDF_HOME_PLUGINS)\$($this.plugin.name)\install.ps1") {
            ."$([AsdfStatics]::ASDF_HOME_PLUGINS)\$($this.plugin.name)\install.ps1"
        }
        Remove-Item -Recurse -Path $path_install_tmp
        Write-Warning "$($this.plugin.name) $($this.name) installed"
        
    }

    [string] getUrl() {
        if (Test-Path "$([AsdfStatics]::ASDF_HOME_PLUGINS)\$($this.plugin.name)\get-url.ps1") {
            $url = ."$([AsdfStatics]::ASDF_HOME_PLUGINS)\$($this.plugin.name)\get-url.ps1"
        } else {
            $url = (
                    Get-Content "$([AsdfStatics]::ASDF_HOME_PLUGINS)\$($this.plugin.name)\versions.json"
                        | ConvertFrom-Json
                        | Where-Object { $_.name -eq $this.name }
                ).url
        }
        return $url
    }

    [void] recreatePath([string]$dest) {
        if (Test-Path $dest) {
            Remove-Item -Recurse -Path $dest
        }
        New-Item -ItemType Directory -Path $dest
    }

}
