function java() {
    .$ASDF_HOME\scripts\plugins\set-env-recursive.ps1
    if ($env:JAVA_HOME) {
        if (test-path $env:JAVA_HOME) {
            ."${env:JAVA_HOME}\bin\java.exe" $args 
        }
    }
}