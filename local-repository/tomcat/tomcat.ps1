Param (
    [ValidateSet("version", "startup", "shutdown")]
    $command
)

Process {
    ."${PSScriptRoot}\bin\${command}.bat"
}
