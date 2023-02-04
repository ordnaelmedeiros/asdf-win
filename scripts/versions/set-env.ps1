$path_plugin = "${ASDF_HOME}\libs\${plugin}"
$path = "${path_plugin}\${version}"

$config = (Get-Content "${ASDF_HOME}\plugins\${plugin}\config.json" | ConvertFrom-Json)

if (test-path $path) {
    if ($terminal) {
        [Environment]::SetEnvironmentVariable($config.envName, $path)
    }
    if ($global) {
        [Environment]::SetEnvironmentVariable($config.envName, $path, 'User')
        echo "Info: Required to restart application/Powershell"
    }
} else {
    echo "Error: ${plugin} - ${local} not installed"
}
