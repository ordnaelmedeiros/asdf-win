if ($name) {
    $path = "$([AsdfStatics]::ASDF_HOME_PLUGINS)\${name}\help.txt"
    if (Test-Path $path) {
        Get-Content $path
    } else {
        Write-Output "No documentation for plugin ${name}"
    }
} else {
    Get-Content "$([AsdfStatics]::ASDF_HOME)\help.txt"
}
