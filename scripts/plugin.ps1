$pluginManager = [AsdfPluginManager]::new()

if ($command -eq "list") {
    if ($name -eq "all") {
        $pluginManager.all().name
    } else {
        $pluginManager.installed().name
    }
} elseif ($command -eq "add") {
    $pluginManager.add($name)
} elseif ($command -eq "remove") {
    $pluginManager.remove($name)
} elseif ($command -eq "update") {
    if ($name) {
        $pluginManager.update($name)
    } elseif ($all) {
        $pluginManager.updateAll()
    } else {
        Write-Warning "Plugin is required"
    }
} else {
    $pluginManager.installed().name
}
