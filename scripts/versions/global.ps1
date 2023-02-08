$path = "$HOME\.win-tool-versions"

# $list.RemoveAt(0)
# 1..3 | Select-Object -Skip 1

if (!(Test-Path $path)) {
    Write-Output "" >> $path
}

$content = Get-Content $path
    | Select-String -Pattern "$plugin" -NotMatch
    | Select-String -Pattern "\S"

Set-Content -Path $path -Value $content

Write-Output "${plugin} ${version}" >> $path
