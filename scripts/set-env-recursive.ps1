$array = $PWD.ToString().split("\")
$versionspath = ""

Get-Content "$HOME\.win-tool-versions" |
    ForEach-Object {
        $pluginarray = $_.split(" ")
        $p = $pluginarray[0]
        $l = $pluginarray[1]
        asdf env $p $l -terminal
    }

foreach ( $i in $array ) {
    $versionspath += $i + "\"
    if (Test-Path "$versionspath.win-tool-versions") {
        Get-Content "$versionspath.win-tool-versions" |
            ForEach-Object {
                $pluginarray = $_.split(" ")
                $p = $pluginarray[0]
                $l = $pluginarray[1]
                asdf env $p $l -terminal
            }
    }
}