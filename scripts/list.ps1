$pluginManager = [AsdfPluginManager]::new()

function showByFilters() {
    foreach($v in $list) {
        if ($filter) {
            $msg = "none"
            foreach($f in $filter) {
                if ($v -like "*$f*") {
                    $msg = $v
                }
            }
            if ($msg -ne "none") {
                Write-Output $msg
            }
        } else {
            Write-Output $v
        }
    }
}

if ($all) {
    if ($name) {
        $list = ($pluginManager.installed() | Where-Object { $_.name -eq $name }).all().name
        showByFilters
    } else {
        Write-Warning "Plugin is required"
    }
} elseif ($name) {
    $list = ($pluginManager.installed() | Where-Object { $_.name -eq $name }).installed().name
    showByFilters
} else {
    foreach($p in $pluginManager.installed()) {
        Write-Output $p.name
        foreach($v in $p.installed()) {
            Write-Output "  $($v.name)"
        }
    }
}
