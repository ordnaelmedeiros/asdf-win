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

}
