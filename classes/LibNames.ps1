Class LibNames : System.Management.Automation.IValidateSetValuesGenerator {
    [string[]] GetValidValues() {
        $Defaults = @("list")
        $Libs = foreach ($i in (dir "~/.asdf/plugins").Name) {
            (Get-Content "~/.asdf/plugins/${i}/versions.json" | ConvertFrom-Json ).name
        }
        $LibNames = $Defaults + $Libs
        return [string[]] $LibNames
    }
}
