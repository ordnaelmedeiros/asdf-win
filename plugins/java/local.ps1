$path_plugin = "${ASDF_HOME}/libs/${plugin}"
$path = "${path_plugin}/${local}"

if (test-path $path) {
    [Environment]::SetEnvironmentVariable("JAVA_HOME", $path)
} else {
    echo "Error: ${plugin} - ${local} not installed"
}
