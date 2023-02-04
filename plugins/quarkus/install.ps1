$path_plugin = "${ASDF_HOME}/libs/${plugin}"
$path = "${path_plugin}/${lib}"
$path_jar = "${path}.jar"

if (!(test-path $path_plugin)) {
    mkdir -p $path_plugin
}

$url = 
    (
        Get-Content $ASDF_HOME/plugins/${plugin}/versions.json 
        | ConvertFrom-Json
        | Where-Object { $_.name -eq $lib }
    ).url

if ($url) {
    curl $url --output $path_jar
} else {
    echo "${plugin} - ${lib} not found"
}
