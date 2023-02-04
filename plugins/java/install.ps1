$path_plugin = "${ASDF_HOME}/libs/${plugin}"
$path = "${path_plugin}/${lib}"
$path_zip = "${path}.zip"
$path_temp = "${path}_temp"

if (!(test-path $path_plugin)) {
    mkdir -p $path_plugin
}
if (test-path $path_zip) {
    rm -r -fo $path_zip
}
if (test-path $path_temp) {
    rm -r -fo $path_temp
}

$url = 
    (
        Get-Content $ASDF_HOME/plugins/${plugin}/versions.json 
        | ConvertFrom-Json
        | Where-Object { $_.name -eq $lib }
    ).url

if ($url) {
    curl $url --output $path_zip
    Expand-Archive -LiteralPath $path_zip -DestinationPath $path_temp
    if (test-path $path) {
        rm -r -fo $path
    }
    mv ${path_temp}/*/ $path
    rm -r -fo $path_temp
} else {
    echo "${plugin} - ${lib} not found"
}
