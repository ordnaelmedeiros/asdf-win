function mvn() {
    ."$ASDF_HOME_SCRIPTS\set-env-recursive.ps1"
    if (Test-Path $env:MVN_HOME\bin\mvn.cmd) {
        ."${env:MVN_HOME}\bin\mvn.cmd" $args
    } else {
        ."${env:MVN_HOME}\bin\mvn.bat" $args
    }
}
