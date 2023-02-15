$ASDF_UPDATELOG_FILE = "${HOME}\.asdf\update.log"
if (!(Test-Path $ASDF_UPDATELOG_FILE)) {
    Get-Date > $ASDF_UPDATELOG_FILE
}
if (Get-ChildItem $ASDF_UPDATELOG_FILE | Where-Object { $_.LastWriteTime -le (Get-Date).AddDays(-6) }) {
    Get-Date > $ASDF_UPDATELOG_FILE
    Write-Warning "asdf updating ..."
    git -C "${HOME}\.asdf" pull
    . "${HOME}\.asdf\asdf.ps1"
    asdf plugin update -all
} else {
    . "${HOME}\.asdf\asdf.ps1"
}
