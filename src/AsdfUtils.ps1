class AsdfUtils {

    static [void] trace([string]$msg) {
        Write-Information $msg -InformationAction Continue
    }

}
