$array = $PWD.ToString().split("\")
$versionspath = ""

Get-Content "$HOME\.win-tool-versions" |
    ForEach-Object {
        $pluginarray = $_.split(" ")
        $p = $pluginarray[0]
        $l = $pluginarray[1]
        asdf $p $l -t
    }

foreach ( $i in $array ) {
    $versionspath += $i + "\"
    if (test-path "$versionspath.win-tool-versions") {
        Get-Content "$versionspath.win-tool-versions" |
            ForEach-Object {
                $pluginarray = $_.split(" ")
                $p = $pluginarray[0]
                $l = $pluginarray[1]
                asdf $p $l -t
            }
    }
}