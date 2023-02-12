$ASDF_HOME = "${HOME}\.asdf"
$ASDF_HOME_SCRIPTS = "${ASDF_HOME}\scripts"
$ASDF_HOME_PLUGINS = "${ASDF_HOME}\plugins"
$ASDF_HOME_LOCAL_REPO = "${ASDF_HOME}\local-repository"
$ASDF_HOME_INSTALLS = "${ASDF_HOME}\installs"
$ASDF_HOME_DOWNLOADS = "${ASDF_HOME}\downloads"

$PLUGINS_NAMES = (Get-Item $ASDF_HOME_LOCAL_REPO\*).Name
$VERSIONS_NAMES = @()
foreach ($i in (Get-Item $ASDF_HOME_PLUGINS\*).Name) {
    $VERSIONS_NAMES += (Get-Content "$ASDF_HOME_PLUGINS\$i\versions.json" | ConvertFrom-Json).name
}

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
    $RuntimeDefinedParameter = New-Object System.Management.Automation.RuntimeDefinedParameter("$paramname", [string], $attributeCollection)
    return $RuntimeDefinedParameter
}

function asdf() {

    Param (

        [Parameter(Position=0)]
        [ValidateSet("list", "plugin", "global", "local", "install", "uninstall", "env")]
        [Alias('c')]
        [string]$command,

        [switch]$terminal,
        [switch]$global

    )

    DynamicParam {

        $paramDictionary = New-Object System.Management.Automation.RuntimeDefinedParameterDictionary
        
        if ($command -eq "plugin") {

            $paramname = "plugincmd"
            $position = 1
            $validateSet = @("list", "add", "remove", "update")
            $p = Create-Param-Asdf
            $paramDictionary.Add("$paramname", $p)

            $paramname = "plugin"
            $position = 2
            $validateSet = @("all") + $PLUGINS_NAMES
            $p = Create-Param-Asdf
            $paramDictionary.Add("$paramname", $p)
            
        } elseif ($command -eq "install" -or $command -eq "global" -or $command -eq "local" -or $command -eq "uninstall" -or $command -eq "env") {

            $paramname = "name"
            $position = 1
            $validateSet = $PLUGINS_NAMES
            $p = Create-Param-Asdf
            $paramDictionary.Add("$paramname", $p)

            $paramname = "version"
            $position = 2
            $validateSet = $VERSIONS_NAMES
            $p = Create-Param-Asdf
            $paramDictionary.Add("$paramname", $p)

        } elseif ($command -eq "list") {

            $paramname = "name1"
            $position = 1
            $validateSet = @("all") + $PLUGINS_NAMES
            $p = Create-Param-Asdf
            $paramDictionary.Add("$paramname", $p)

            $paramname = "name2"
            $position = 2
            $validateSet = $PLUGINS_NAMES
            $p = Create-Param-Asdf
            $paramDictionary.Add("$paramname", $p)

        }
        return $paramDictionary
    }
    Begin{
        $plugincmd = $PSBoundParameters['plugincmd']
        $plugin = $PSBoundParameters['plugin']
        $name = $PSBoundParameters['name']
        $version = $PSBoundParameters['version']

        $name1 = $PSBoundParameters['name1']
        $name2 = $PSBoundParameters['name2']
    }
    Process {
        if ($command) {
            ."${ASDF_HOME_SCRIPTS}\${command}.ps1"
        }
    }
}

foreach ($p in (Get-Item "${ASDF_HOME_PLUGINS}\*")) {
    . "${p}\exec.ps1"
}
