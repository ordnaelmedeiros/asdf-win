# asdf install <name> latest[:<version>]  Install the latest stable version of a
#                                         package, or with optional version,
#                                         install the latest stable version that
#                                         begins with the given string

$pluginManager = [AsdfPluginManager]::new()

if ($name -and $version) {
    $pluginManager.plugin($name).version($version).install()
} elseif ($name) {
    $item = $pluginManager.readByfile($PWD) | Where-Object { $_.plugin.name -eq $name }
    $pluginManager.add($item.plugin.name)
    $pluginManager.plugin($item.plugin.name).version($item.name).install()
} else {
    foreach ($item in $pluginManager.readByfile($PWD)) {
        $pluginManager.add($item.plugin.name)
        $pluginManager.plugin($item.plugin.name).version($item.name).install()
    }
}
