Class PluginsNames : System.Management.Automation.IValidateSetValuesGenerator {
    [string[]] GetValidValues() {
        $Defalts = @("version", "list", "update")
        $Names = (dir "~/.asdf/plugins").Name
        $PluginsNames = $Defalts + $Names
        return [string[]] $PluginsNames
    }
}
