$path_plugin = "${ASDF_HOME}/libs/${plugin}"
$path = "${path_plugin}/${global}.jar"

if (test-path $path) {
    [Environment]::SetEnvironmentVariable("QUARKUS_JAR", $path, "User")
    echo "Info: Required to restart application/Powershell"
} else {
    echo "Error: ${plugin} - ${global} not installed"
}
