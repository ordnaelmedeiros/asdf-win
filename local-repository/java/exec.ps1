function java() {
    ."$ASDF_HOME_SCRIPTS\set-env-recursive.ps1"
    ."${env:JAVA_HOME}\bin\java.exe" $args 
}