$config = (Get-Content "${ASDF_HOME}\plugins\${plugin}\config.json" | ConvertFrom-Json)
$fileType = $config.fileType;

$path_cache = "${ASDF_HOME}\cache\${plugin}"
$path_plugin = "${ASDF_HOME}\libs\${plugin}"
$path = "${path_plugin}\${version}"
$path_download = "${path_cache}\${version}.${fileType}"
$path_temp = "${path}_temp"

if (test-path $path) {
    return
}

if (!(test-path $path_cache)) {
    mkdir -p $path_cache
}
if (!(test-path $path_plugin)) {
    mkdir -p $path_plugin
}
if (test-path $path_temp) {
    rm -r -fo $path_temp
}

$url = 
    (
        Get-Content $ASDF_HOME/plugins/${plugin}/versions.json 
        | ConvertFrom-Json
        | Where-Object { $_.name -eq $version }
    ).url

if ($url) {
    if (test-path $path_download) {
        echo "cache $path_download"
    } else {
        curl $url --output $path_download
    }
    if ($fileType -eq "zip") {
        if ($url.EndsWith(".zip")) {
            echo "pelo zip"
            Expand-Archive -LiteralPath $path_download -DestinationPath $path_temp
        } else {
            echo "pelo tar.gz"
            mkdir -p $path_temp
            tar -xvzf $path_download -C $path_temp
        }
        if (test-path $path) {
            rm -r -fo $path
        }
        mv ${path_temp}/*/ $path
        rm -r -fo $path_temp
    } else {
        cp $path_download $path
    }
    echo "${plugin} - ${version} installed"
} else {
    echo "${plugin} - ${version} not found"
}
