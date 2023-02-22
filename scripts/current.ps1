class CurrentVersion {
    [string]$name
    [string]$version
    [string]$path
}

$pluginManager = [AsdfPluginManager]::new()

if ($name) {
    $plugins = $pluginManager.installed() | Where-Object { $_.name -eq $name }
} else {
    $plugins = $pluginManager.installed()
}

foreach($p in $plugins) {
    $v = $p.current()
    # Write-output "$($p.name) - $($v.name) - $($v.path)"
    $info = [CurrentVersion]::new()
    $info.name = $p.name
    $info.version = $v.name
    $info.path = $v.path
    Write-output $info
}

