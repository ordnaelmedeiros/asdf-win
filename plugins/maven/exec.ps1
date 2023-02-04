function mvn() {
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