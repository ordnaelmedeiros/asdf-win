$ASDF_HOME = "${HOME}\.asdf"
$ASDF_HOME_SRC = "${HOME}\.asdf\src"
$ASDF_HOME_SCRIPTS = "${ASDF_HOME}\scripts"
$ASDF_HOME_PLUGINS = "${ASDF_HOME}\plugins"
$ASDF_HOME_LOCAL_REPO = "${ASDF_HOME}\local-repository"
$ASDF_HOME_INSTALLS = "${ASDF_HOME}\installs"
$ASDF_HOME_DOWNLOADS = "${ASDF_HOME}\downloads"

$PLUGINS_NAMES = (Get-Item $ASDF_HOME_LOCAL_REPO\*).Name

."$ASDF_HOME_SCRIPTS\import.ps1"

function Create-Param-Asdf() {

    # echo "paramname: $paramname" >> "$ASDF_HOME\log.txt"
    # echo "position: $position" >> "$ASDF_HOME\log.txt"
    # echo "validateSet: $validateSet" >> "$ASDF_HOME\log.txt"

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
        [ValidateSet("plugin", "current", "list", "global", "local", "install", "uninstall", "update", "env")]
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
            $validateSet = @("all") + $PLUGINS_NAMES
            $p = Create-Param-Asdf
            $paramDictionary.Add("$paramname", $p)
        
        } elseif (("current").contains($program)) {

            $paramname = "name"
            $position = 1
            $validateSet = $PLUGINS_NAMES
            $p = Create-Param-Asdf
            $paramDictionary.Add("$paramname", $p)

        } elseif (("install", "global", "local", "uninstall", "env").contains($program)) {

            $paramname = "name"
            $position = 1
            $validateSet = $PLUGINS_NAMES
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
            $validateSet = $PLUGINS_NAMES
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

$PromptScript = (Get-Command Prompt).ScriptBlock
$EnvPathBacup = $env:PATH.Split(";") | Select-String -Pattern "asdf" -NotMatch | Join-String -Separator ";"

function Prompt {

    $infos = @{}
    $infosLocal = @{}
    
    Get-Content "$HOME\.win-tool-versions" |
        ForEach-Object {
            $pluginarray = $_.split(" ")
            $p = $pluginarray[0]
            $l = $pluginarray[1]
            $infos[$p] = $l
        }
    $array = $PWD.ToString().split("\")
    foreach ( $i in $array ) {
        $versionspath += $i + "\"
        if (Test-Path "$versionspath.win-tool-versions") {
            Get-Content "$versionspath.win-tool-versions" |
                ForEach-Object {
                    $pluginarray = $_.split(" ")
                    $p = $pluginarray[0]
                    $l = $pluginarray[1]
                    $infos[$p] = $l
                    $infosLocal[$p] = $l
                }
        }
    }

    $env:PATH = $EnvPathBacup
    foreach ($Key in $infos.Keys) {
        if (Test-Path "$ASDF_HOME_PLUGINS\$Key") {
            $pluginConfig = (Get-Content "$ASDF_HOME_PLUGINS\$Key\config.json" | ConvertFrom-Json)
            $winPath = $pluginConfig.winPath
            $envName = $pluginConfig.envName
            [Environment]::SetEnvironmentVariable($envName, "$ASDF_HOME_INSTALLS\$Key\$($infos[$Key])")
            $env:PATH += ";$ASDF_HOME_INSTALLS\$Key\$($infos[$Key])$winPath"
            $infosToText += "$Key $($infos[$Key]) | "
        }
    }

    if ((Get-Content "$HOME\.asdf-config" | ConvertFrom-Json).showPromptVersions -eq "true") {
        $infosToText = ""
        foreach ($Key in $infosLocal.Keys) {
            $infosToText += "| $Key $($infos[$Key]) "
        }
        Write-Host -ForegroundColor DarkGreen $infosToText # -NoNewline
    }
    .$PromptScript

}
