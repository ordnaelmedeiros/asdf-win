$path_plugin = "${ASDF_HOME}/libs/${plugin}"
$path = "${path_plugin}/${global}"

if (test-path $path) {
    [Environment]::SetEnvironmentVariable("MVN_HOME", $path, 'User')
    echo "Info: Required to restart application/Powershell"
} else {
    echo "Error: ${plugin} - ${local} not installed"
}
