$path = "${ASDF_HOME_INSTALLS}\${name}\${version}"
$config = (Get-Content "${ASDF_HOME_PLUGINS}\${name}\config.json" | ConvertFrom-Json)

# echo "terminal: $terminal"
# echo "global: $global"

if (Test-Path $path) {
    if ($terminal) {
        [Environment]::SetEnvironmentVariable($config.envName, $path)
    }
    if ($global) {
        [Environment]::SetEnvironmentVariable($config.envName, $path, 'User')
        echo "Info: Required to restart application/Powershell"
    }
} else {
    echo "Error: ${name} - ${version} not installed"
}
