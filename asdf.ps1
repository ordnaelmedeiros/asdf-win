$ASDF_HOME = "${HOME}\.asdf"
$ASDF_HOME_SRC = "${HOME}\.asdf\src"
$ASDF_HOME_SCRIPTS = "${ASDF_HOME}\scripts"
$ASDF_HOME_PLUGINS = "${ASDF_HOME}\plugins"
$ASDF_HOME_LOCAL_REPO = "${ASDF_HOME}\local-repository"
$ASDF_HOME_REPO = "${ASDF_HOME}\repository"
$ASDF_HOME_INSTALLS = "${ASDF_HOME}\installs"
$ASDF_HOME_DOWNLOADS = "${ASDF_HOME}\downloads"

."$ASDF_HOME_SCRIPTS\import.ps1"

if (-not (Test-Path "$ASDF_HOME_REPO\README.md")) {
    $TMP_PLUGINS_NAMES = (Get-Item "$ASDF_HOME_REPO\plugins\*").Name
    Remove-Item -Recurse -Force -Path "$ASDF_HOME_REPO"
    Remove-Item -Recurse -Force -Path "$ASDF_HOME_PLUGINS"
}
if (-not (Test-Path "$ASDF_HOME_REPO")) {
    git clone "https://github.com/ordnaelmedeiros/asdf-win-plugins" "$ASDF_HOME_REPO"
}

# $PLUGINS_NAMES = (Get-Item "$ASDF_HOME_REPO\plugins\*").Name

function Create-Param-Asdf() {
    $ParameterAttribute = New-Object System.Management.Automation.ParameterAttribute
    $ParameterAttribute.Position = $position
    $AttributeCollection = New-Object System.Collections.ObjectModel.Collection[System.Attribute]
    $AttributeCollection.Add($ParameterAttribute)
    if ($validateSet.Length -gt 0) {
        $ValidateSetAttribute = New-Object System.Management.Automation.ValidateSetAttribute($validateSet)
        $AttributeCollection.Add($ValidateSetAttribute)
    }
    $RuntimeDefinedParameter = New-Object System.Management.Automation.RuntimeDefinedParameter("$paramname", $paramtype, $attributeCollection)
    return $RuntimeDefinedParameter
}

function asdf() {

    Param (

        [Parameter(Position=0)]
        [ValidateSet("plugin", "current", "list", "global", "help", "local", "install", "uninstall", "update")]
        [string]$program,

        [switch]$terminal,
        [switch]$global,
        [switch]$all

    )

    DynamicParam {

        $paramDictionary = New-Object System.Management.Automation.RuntimeDefinedParameterDictionary
        
        $paramtype = [string]

        if ($program -eq "plugin") {

            $paramname = "command"
            $position = 1
            $validateSet = @("list", "add", "remove", "update")
            $p = Create-Param-Asdf
            $paramDictionary.Add("$paramname", $p)

            $paramname = "name"
            $position = 2
            # $validateSet = @("all") + $PLUGINS_NAMES
            $validateSet = @()
            $p = Create-Param-Asdf
            $paramDictionary.Add("$paramname", $p)
        
            $paramname = "url"
            $position = 3
            $validateSet = @()
            $p = Create-Param-Asdf
            $paramDictionary.Add("$paramname", $p)

        } elseif (("current", "help").contains($program)) {

            $paramname = "name"
            $position = 1
            # $validateSet = $PLUGINS_NAMES
            $validateSet = @()
            $p = Create-Param-Asdf
            $paramDictionary.Add("$paramname", $p)

        } elseif (("install", "global", "local", "uninstall").contains($program)) {

            $paramname = "name"
            $position = 1
            # $validateSet = $PLUGINS_NAMES
            $validateSet = @()
            $p = Create-Param-Asdf
            $paramDictionary.Add("$paramname", $p)

            $paramname = "version"
            $position = 2
            $validateSet = @()
            $p = Create-Param-Asdf
            $paramDictionary.Add("$paramname", $p)

        } elseif ($program -eq "list") {

            $paramname = "name"
            $position = 1
            # $validateSet = $PLUGINS_NAMES
            $validateSet = @()
            $p = Create-Param-Asdf
            $paramDictionary.Add("$paramname", $p)

            $paramname = "filter"
            $paramtype = [string[]]
            $position = 2
            $validateSet = @()
            $p = Create-Param-Asdf
            $paramDictionary.Add("$paramname", $p)

        }
        return $paramDictionary
    }
    Begin{
        $command = $PSBoundParameters['command']
        $plugin = $PSBoundParameters['plugin']
        $name = $PSBoundParameters['name']
        $version = $PSBoundParameters['version']
        $filter = $PSBoundParameters['filter']
        $url = $PSBoundParameters['url']
    }
    Process {
        if ($program) {
            ."${ASDF_HOME_SCRIPTS}\${program}.ps1"
        } else {
            Get-Content "$ASDF_HOME\help.txt"
            Get-Content "$ASDF_HOME\banner.txt"
            Get-Content "$ASDF_HOME\version.txt"
        }
    }
}

if ($TMP_PLUGINS_NAMES) {
    foreach ($p in $TMP_PLUGINS_NAMES) {
        asdf plugin add $p
    }
}

$PromptScript = (Get-Command Prompt).ScriptBlock
$EnvPathBackup = $env:PATH.Split(";") | Select-String -Pattern "asdf" -NotMatch | Join-String -Separator ";"

function Prompt {

    try {

        [System.Collections.ArrayList]$plugins = [AsdfUtils]::readByfile([AsdfStatics]::HOME)
        $versionspath = ""
        $array = $PWD.ToString().split("\")
        foreach ($i in $array) {
            $versionspath += $i + "\"
            $others = [AsdfUtils]::readByfile($versionspath)
            if ($others) {
                foreach ($o in $others) {
                    $p = $plugins | Where-Object { $_.plugin.name -eq $o.plugin.name }
                    if ($p) {
                        $plugins.Remove($p)
                    }
                    $plugins += $o
                }
            }
        }
        
        $pathTmp = ""
        foreach ($v in $plugins) {
            $pathTmp += "$($v.pathInstalledExe());"
            $v.configEnv("Shell")
        }
        $env:PATH = $pathTmp + $EnvPathBackup

    } catch {
        Write-Host "$_"
    }

    .$PromptScript

}
