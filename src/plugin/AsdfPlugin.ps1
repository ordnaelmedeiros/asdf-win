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
                $list += [AsdfVersion]::new($i.Name)
            }
        }
        return $list
    }

    [AsdfVersion[]] all() {
        $list = @()
        foreach($i in (Get-Content "$([AsdfStatics]::ASDF_HOME_PLUGINS)\$($this.name)\versions.json" | ConvertFrom-Json)) {
            $list += [AsdfVersion]::new($i.Name)
        }
        return $list
    }

}
