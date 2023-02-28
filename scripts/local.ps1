# asdf local <name> latest[:<version>]    Set the package local version to the
#                                         latest provided version

$pluginManager = [AsdfPluginManager]::new()

if ($name -and $version) {
    $version = ($pluginManager.installed() | Where-Object { $_.name -eq $name }).installed() | Where-Object { $_.name -eq $version }
    if ($version) {
        $version.local()
    } else {
        Write-Warning "name or version not found"
    }
} else {
    Write-Warning "name and version required"
}
