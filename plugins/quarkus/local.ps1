$path_plugin = "${ASDF_HOME}/libs/${plugin}"
$path = "${path_plugin}/${local}.jar"

if (test-path $path) {
    [Environment]::SetEnvironmentVariable("QUARKUS_JAR", $path)
} else {
    echo "Error: ${plugin} - ${local} not installed"
}
