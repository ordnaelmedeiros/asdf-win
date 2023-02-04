$ASDF_HOME = "${HOME}\.asdf"
$ASDF_SCRIPTS = "${ASDF_HOME}\scripts"
$ASDF_CLASSES = "${ASDF_HOME}\classes"

$PLUGINS_NAMES = (dir "~\.asdf\plugins").Name

. $ASDF_CLASSES/PluginsNames.ps1
. $ASDF_CLASSES/LibNames.ps1

function asdf() {
    param (
        [Alias('p')]
        [ValidateSet([PluginsNames])]
        [string]$plugin,

        [Alias('i')]
        [ValidateSet([LibNames])]
        [string]$version,

        [Alias('g')]
        [switch]$global,

        [Alias('t')]
        [switch]$terminal
    )
    
    if (!$plugin) {
        .$ASDF_SCRIPTS\version.ps1
        return
    } elseif ($plugin -eq "version") {
        .$ASDF_SCRIPTS\version.ps1
        return
    } elseif ($plugin -eq "list") {
        .$ASDF_SCRIPTS\plugins\list.ps1
        return
    } else {
        if (!$version) {
            .$ASDF_SCRIPTS\versions\list.ps1
        } elseif ($version -eq "list") {
            .$ASDF_SCRIPTS\versions\list.ps1
        } else {
            .$ASDF_SCRIPTS\versions\install.ps1
            .$ASDF_SCRIPTS\versions\set-env.ps1
        }
    }

} 

foreach ($p in $PLUGINS_NAMES) {
    . "${ASDF_HOME}\plugins\${p}\exec.ps1"
}
