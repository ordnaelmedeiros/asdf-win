Class PluginsNames : System.Management.Automation.IValidateSetValuesGenerator {
    [string[]] GetValidValues() {
        $Defalts = @("version", "list")
        $Names = (dir "~/.asdf/plugins").Name
        $PluginsNames = $Defalts + $Names
        return [string[]] $PluginsNames
    }
}
