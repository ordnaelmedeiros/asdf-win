function mvn() {
    .$ASDF_HOME\scripts\plugins\set-env-recursive.ps1
    if ($env:MVN_HOME) {
        if (test-path $env:MVN_HOME) {
            if (test-path $env:MVN_HOME\bin\mvn.cmd) {
                ."${env:MVN_HOME}\bin\mvn.cmd" $args
            } else {
                ."${env:MVN_HOME}\bin\mvn.bat" $args
            }
        }
    }
}